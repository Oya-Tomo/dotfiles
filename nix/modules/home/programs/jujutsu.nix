{ config, pkgs, lib, ... }:

{
  programs.jujutsu = {
    enable = true;
  };

  xdg.configFile."jj".source = ./../../../../jj;
}
