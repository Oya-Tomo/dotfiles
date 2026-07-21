{ config, pkgs, lib, userConfig, ... }:

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

  home = {
    inherit (userConfig) username homeDirectory;
    stateVersion = "25.05";
  };

  programs.home-manager.enable = true;

  targets.genericLinux.enable = true;

  targets.genericLinux.gpu = {
    enable = true;
    nvidia = {
      enable = true;
      version = "595.71.05";
      sha256 = "sha256-NiA7iWC35JyKQva6H1hjzeNKBek9KyS3mK8G3YRva4I=";
    };
  };
}
