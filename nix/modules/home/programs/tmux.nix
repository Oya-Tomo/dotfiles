{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    tmux
  ];

  xdg.configFile."tmux".source = ./../../../../tmux;
}
