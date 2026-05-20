{ config, pkgs, lib, ... }:

{
  imports = [
    ./packages.nix
    ./programs
    ./dotfiles.nix
  ];

  nixpkgs.config = {
    allowUnfree = true;
    nvidia.acceptLicense = true;
  };

  home.username = "oyatomo";
  home.homeDirectory = "/home/oyatomo";
  home.stateVersion = "25.05";

  programs.home-manager.enable = true;

  targets.genericLinux.enable = true;

  targets.genericLinux.gpu = {
    enable = true;
    nvidia = {
      enable = true;
      version = "595.58.03";
      # Get sha256 with: nix-prefetch-url https://download.nvidia.com/XFree86/Linux-x86_64/595.58.03/NVIDIA-Linux-x86_64-595.58.03.run
      sha256 = "sha256-jA1Plnt5MsSrVxQnKu6BAzkrCnAskq+lVRdtNiBYKfk=";
    };
  };
}
