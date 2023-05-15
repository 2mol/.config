# Juri's "dotfiles"



## initial setup

```bash
git init --bare $HOME/.cfg
alias config='git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
config config --local status.showUntrackedFiles no
```

```bash
config add ~/.config/nixpkgs
config commit -m "add nix configuration"
```

-> add a remote


## new machine:

```bash
git clone --bare git@github.com:2mol/.config.git $HOME/.cfg
alias config='git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
config config --local status.showUntrackedFiles no
config checkout
```

...then install home-manager

## nix

update installed packages:

```bash
nix flake update ~/.config/home-manager
home-manager switch
```

