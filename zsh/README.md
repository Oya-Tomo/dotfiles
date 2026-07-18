# Zsh Configuration

Zsh is installed system-wide by the host package manager so it can be listed
in `/etc/shells` and used as the login shell. Home Manager deploys only the
user configuration from this directory.

## Files

- `.zshenv` sets `ZDOTDIR` to `~/.config/zsh` and loads the Home Manager
  session environment for non-login shells.
- `.zprofile` loads the Home Manager session environment for login shells.
- `.zshrc` contains history, aliases, completion, prompt, and tool integration.

## Ubuntu/Debian setup

Install zsh and select it as the login shell before applying Home Manager:

```bash
sudo apt update
sudo apt install zsh
chsh -s /usr/bin/zsh
```

Then apply the dotfiles:

```bash
nix run home-manager -- switch --flake ~/dotfiles
```
