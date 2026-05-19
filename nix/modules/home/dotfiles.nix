{ config, pkgs, lib, ... }:

{
  xdg.configFile = {
    "starship.toml".source = ./../../../starship.toml;
    "nvim".source = ./../../../nvim;
    "wezterm".source = ./../../../wezterm;
    "lazygit".source = ./../../../lazygit;
    "ghostty".source = ./../../../ghostty;
    "batto".source = ./../../../batto;
  };
}
