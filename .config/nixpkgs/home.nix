{ pkgs, lib, ... }:

{
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = (pkg: true);

  home.stateVersion = "22.11";
  home.username = "juri";
  home.homeDirectory = "/Users/juri/";

  home.packages = with pkgs; [
    # Unix basics
    git git-lfs
    htop tmux tmate coreutils
    curl wget
    aria2 # httpie
    unar killall sshfs parallel
    difftastic

    # Nu-Unix excellence
    ripgrep fd fzf bat exa jq
    micro glow

    # other useful tools
    shellcheck entr watch
    sqlite-interactive sqlite-utils # dbmate
    qrencode # image_optim (not supported on M1)
    imagemagick graphviz ffmpeg
    yt-dlp
    opusTools vorbis-tools

    # Nix utils
    direnv nix-direnv
    nixpacks

    # dev and random nice-to-haves
    zola restic
    ngrok
    #docker colima
    pspg # (broken) pgcli dbmate
    lazygit
    elmPackages.elm-format

    # Wave
    yarn # semgrep (no M1)

    # fonts
    meslo-lgs-nf iosevka-bin hack-font
    ibm-plex inter jetbrains-mono
  ];

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

  home.sessionVariables = {
    EDITOR = "nvim";
    #PAGER = "pspg --force-uniborder -s 23";
  };

  programs.home-manager = {
    enable = true;
    # path = "…";
  };
  
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    shellAliases = {
      l = "exa --group-directories-first";
      ls = "exa --group-directories-first";
      ll = "exa -l --group-directories-first";
      la = "exa -la --group-directories-first";
      less = "less -R"; # TODO: this prob only works on mac
      tf = "terraform";
      config = "git --git-dir=$HOME/.cfg/ --work-tree=$HOME";
      config-help = "glow $HOME/.config/README.md";
      config-update = "nix flake update ~/.config/nixpkgs";
      config-switch = "home-manager switch --flake ~/.config/nixpkgs#juri";
    };
    history.size = 1000000;

    localVariables = {
      # disable this utter piece of shit oh-my-zsh default (it inserts some
      # stuff when copy-pasting URLs for example)
      DISABLE_MAGIC_FUNCTIONS=true;
    };

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];
    };

    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "powerlevel10k-config";
        src = lib.cleanSource ./.;
        file = "p10k.zsh";
      }
    ];

    initExtra = ''
      bindkey '^[[A' up-line-or-search
      bindkey '^[[B' down-line-or-search
      bindkey "^[[H" beginning-of-line
      bindkey "^[[F" end-of-line

      setopt no_auto_remove_slash

      export PATH=/opt/homebrew/bin:$PATH
      export PATH=$HOME/.local/bin:$PATH

      if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
        . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
      fi

      source $HOME/.env 2> /dev/null
      source $HOME/.waverc 2> /dev/null

      eval "$(rbenv init - zsh)" 2> /dev/null
      '';
  };
  
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
}

