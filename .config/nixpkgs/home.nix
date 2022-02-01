{ pkgs, lib, ... }:

{
  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    # Unix basics
    git git-lfs
    htop tmux tmate coreutils #neovim
    curl curlie httpie wget aria2
    unar killall sshfs

    # Nu-Unix excellence and
    # other useful basic tools
    ripgrep fd fzf bat exa jq
    shellcheck entr watch
    sqlite-interactive
    qrencode youtube-dl
    imagemagick graphviz ffmpeg

    # nix-y shit
    cachix
    direnv nix-direnv

    # dev
    zola restic
    redoc-cli ngrok
    docker colima
    google-cloud-sdk
    terraform
    python39 python39Packages.mypy
    yarn
    #dotnet-sdk_6

    # fonts
    meslo-lgs-nf iosevka-bin hack-font
    ibm-plex inter
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

      nnoremap <leader>ff <cmd>Telescope find_files<cr>
      nnoremap <leader>fg <cmd>Telescope live_grep<cr>
      nnoremap <leader>fb <cmd>Telescope buffers<cr>
      nnoremap <leader>fh <cmd>Telescope help_tags<cr>
    '';
  };

  programs.ssh.extraConfig = ''
    Host github-work
      Hostname github.com
      User jurichome
      IdentityFile ~/.ssh/id_ed25519_work
    Host github-private
      Hostname github.com
      User 2mol
      IdentityFile ~/.ssh/id_ed25519
    Host *
      UseKeychain yes
      AddKeysToAgent yes
      IdentityFile ~/.ssh/id_ed25519
      IdentityFile ~/.ssh/id_ed25519_work
  '';

  programs.git = {
    enable = true;
    #userName = "2mol";
    #userEmail = "2mol@users.noreply.github.com";
    extraConfig = {
      core.editor = "vim";
      pull.rebase = true;
      init.defaultBranch = "main";
    };
  };

  home.sessionVariables = {
    EDITOR = "vim";
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

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];
      #theme = "robbyrussell";
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
      '';
  };
  
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
}

