{ config, pkgs, lib, ... }:

{
  programs.zsh = {
    enable = true;

    history = {
      path = "$HOME/.zsh_history";
      size = 1000000;
      save = 1000000;
      ignoreDups = true;
      ignoreSpace = true;
      share = true;
    };

    shellAliases = {
      ls = "ls --color=auto";
      la = "ls -a --color=auto";
      ll = "ls -l --color=auto";
      lla = "ls -l -a --color=auto";
      l = "ls -CF --color=auto";
      vim = "nvim";
      hms = "home-manager switch --flake ~/dotfiles";
    };

    initContent = builtins.readFile ./../../../zsh/init-extra.zsh;
  };
}
