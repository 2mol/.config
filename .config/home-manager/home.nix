{ config, pkgs, lib, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "juri";
  home.homeDirectory = "/Users/juri";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "22.11"; # Please read the comment before changing.

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = (pkg: true);

  home.packages = with pkgs; [
    nix-info
    # Unix basics
    git git-lfs git-crypt
    htop tmux tmate coreutils
    curl wget
    aria2 # httpie
    unar killall parallel # sshfs
    difftastic
    pandoc

    # dosbox-staging
    dosbox-x

    # Nu-Unix excellence
    ripgrep fd fzf bat eza jq
    micro glow helix

    # other useful tools
    shellcheck entr watch
    sqlite-interactive # sqlite-utils
    xmlstarlet
    qrencode # image_optim (not supported on M1)
    graphviz imagemagick ffmpeg-full
    yt-dlp
    opusTools vorbis-tools

    # Nix utils
    direnv nix-direnv
    nixpacks

    # dev and random nice-to-haves
    zola #restic
    ngrok
    #docker colima
    pspg # (still broken?) pgcli
    lazygit

    # Wave
    yarn
    # (google-cloud-sdk.withExtraComponents [google-cloud-sdk.components.gke-gcloud-auth-plugin])
    vault
    redis
    openjdk
    rbenv pyenv
    watchman
    pgcli
    semgrep
    yamlfmt

    # fonts
    meslo-lgs-nf iosevka-bin hack-font
    ibm-plex inter jetbrains-mono

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # You can also manage environment variables but you will have to manually
  # source
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/juri/etc/profile.d/hm-session-vars.sh
  #
  # if you don't want to manage your shell through Home Manager.
  home.sessionVariables = {
    EDITOR = "vim";
  };

  programs.neovim = {
    enable = true;
    vimAlias = true;
    plugins = with pkgs.vimPlugins; [
      vim-lastplace
      vim-gruvbox8
      nvim-treesitter
      vim-nix
    ];
    extraConfig = ''
      let mapleader="'"
      set mouse=a
      set clipboard+=unnamedplus

      set number
      set hlsearch
      colorscheme gruvbox8

      set tabstop=2       " number of visual spaces per TAB
      set softtabstop=2   " number of spaces in tab when editing
      set shiftwidth=2    " number of spaces to use for autoindent
      set expandtab       " tabs are space
      set autoindent
      set copyindent      " copy indent from the previous line
    '';
  };

  programs.git = {
    enable = true;
    lfs.enable = true;
    extraConfig = {
      core.editor = "vim";
      core.excludesfile = "~/.gitignore";
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
      diff.external = "difft";
    };
    aliases = {
      undo = "reset HEAD~1 --mixed";
      amend = "commit -a --amend";
      co = "checkout";
      sw = "switch";
      lg = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
    };
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    shellAliases = {
      l = "eza --group-directories-first";
      ls = "eza --group-directories-first";
      ll = "eza -l --group-directories-first";
      la = "eza -la --group-directories-first";
      less = "less -R"; # TODO: this prob only works on mac
      tf = "terraform";
      config = "git --git-dir=$HOME/.cfg/ --work-tree=$HOME";
      config-help = "glow $HOME/.config/README.md";
    };

    localVariables = {
      # disable this utter piece of shit oh-my-zsh default (it inserts some
      # stuff when copy-pasting URLs for example)
      DISABLE_MAGIC_FUNCTIONS=true;
    };

    #oh-my-zsh = {
    #  enable = true;
    #  plugins = [ "git" ];
    #};

    #plugins = [
    #  {
    #    name = "powerlevel10k";
    #    src = pkgs.zsh-powerlevel10k;
    #    file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
    #  }
    #  {
    #    name = "powerlevel10k-config";
    #    src = lib.cleanSource ./.;
    #    file = "p10k.zsh";
    #  }
    #];

    initExtra = ''
      source ${pkgs.grml-zsh-config}/etc/zsh/zshrc
      zstyle ':prompt:grml:right:setup' items
      zstyle ':prompt:grml:left:setup' items rc user path vcs percent

      HISTFILE=$HOME/.zsh_history_uncut
      HISTSIZE=999999
      SAVEHIST=999999
      setopt appendhistory
      setopt INC_APPEND_HISTORY  
      setopt SHARE_HISTORY
      setopt HIST_SAVE_NO_DUPS

      bindkey '^[[A' up-line-or-search
      bindkey '^[[B' down-line-or-search
      bindkey "^[[H" beginning-of-line
      bindkey "^[[F" end-of-line

      setopt no_auto_remove_slash

      export PATH=/opt/homebrew/bin:$PATH
      export PATH=$HOME/.local/bin:$PATH
      export USE_GKE_GCLOUD_AUTH_PLUGIN=True

      if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
        . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
      fi

      if command -v fzf-share >/dev/null; then
        source "$(fzf-share)/key-bindings.zsh"
        source "$(fzf-share)/completion.zsh"
      fi

      # source $HOME/.waverc 2> /dev/null
      '';
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}

