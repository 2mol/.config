{ pkgs, lib, ... }:

{
  nixpkgs.config.allowUnfree = true;

  home.stateVersion = "22.05";
  home.username = "juri";
  home.homeDirectory = "/Users/juri/";

  home.packages = with pkgs; [
    # Unix basics
    git git-lfs
    htop tmux tmate coreutils
    curl wget
    #curlie httpie aria2
    unar killall sshfs

    # Nu-Unix excellence and
    # other useful basic tools
    ripgrep fd fzf bat exa jq
    shellcheck entr watch
    sqlite-interactive litecli
    qrencode
    #yt-dlp
    imagemagick graphviz ffmpeg
    #opusTools vorbis-tools

    # nix-y shit
    #cachix
    direnv nix-direnv lorri

    # dev
    zola restic
    #redoc-cli
    # (unfree) ngrok
    #docker colima
    #google-cloud-sdk
    #terraform
    # (temp broken) dbmate pspg pgcli
    #flyctl
    lazygit

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
      telescope-nvim
      nvim-treesitter
      vim-nix
      vim-terraform
      vim-terraform-completion
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

      nnoremap <leader>ff <cmd>Telescope find_files<cr>
      nnoremap <leader>fg <cmd>Telescope live_grep<cr>
      nnoremap <leader>fb <cmd>Telescope buffers<cr>
      nnoremap <leader>fh <cmd>Telescope help_tags<cr>
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
    };
    aliases = {
      undo = "reset HEAD~1 --mixed";
      amend = "commit -a --amend";
      lg = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
    };
  };

  home.sessionVariables = {
    EDITOR = "vim";
    #PAGER = "pspg --force-uniborder -s 23";
  };

  programs.home-manager = {
    enable = true;
    path = "…";
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
    };
    history.size = 1000000;

    localVariables = {
      # thisable this utter piece of shit bullshit oh-my-zsh default:
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
      export PATH=$HOME/.ghcup/bin:$PATH
      export PATH=$HOME/.cabal/bin:$PATH

      if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
        . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
      fi

      source $HOME/.ghcup/env 2> /dev/null
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

