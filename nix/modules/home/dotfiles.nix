{ config, pkgs, lib, ... }:

{
  xdg.configFile = {
    "starship.toml".source = ./../../../starship.toml;
    "batto".source = ./../../../batto;
  };
}
