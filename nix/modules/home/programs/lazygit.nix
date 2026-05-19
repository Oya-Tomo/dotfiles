{ config, pkgs, lib, ... }:

{
  programs.lazygit = {
    enable = true;
  };

  xdg.configFile."lazygit".source = ./../../../../lazygit;
}
