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


## nix

Install first home-manager flake:

```
nix build --no-link ~/.config/nixpkgs#homeConfigurations.juri.activationPackage
```

Update and switch:

```
nix flake update ~/.config/nixpkgs
home-manager switch --flake ~/.config/nixpkgs#juri
```



## references

- https://www.mathiaspolligkeit.com/dev/exploring-nix-on-macos/

