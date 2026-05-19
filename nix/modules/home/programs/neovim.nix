{ config, pkgs, lib, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    withRuby = false;
    withPython3 = false;
  };

  xdg.configFile."nvim".source = ./../../../../nvim;
}
