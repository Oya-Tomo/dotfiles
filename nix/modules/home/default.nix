{ config, pkgs, lib, ... }:

{
  imports = [
    ./packages.nix
    ./programs
    ./dotfiles.nix
  ];

  home.username = "oyatomo";
  home.homeDirectory = "/home/oyatomo";
  home.stateVersion = "25.05";

  programs.home-manager.enable = true;

  targets.genericLinux.enable = true;
}
