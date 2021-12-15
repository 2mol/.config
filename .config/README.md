
taken from https://www.mathiaspolligkeit.com/dev/exploring-nix-on-macos/


```bash
git init --bare $HOME/.cfg
alias config='git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
config config --local status.showUntrackedFiles no
```

```bash
config add ~/.config/nixpkgs
config commit -m "add nix configuration"
```

new machine:

```bash
git clone --bare <git-repo-url> $HOME/.cfg
alias config='git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
config config --local status.showUntrackedFiles no
config checkout
```
