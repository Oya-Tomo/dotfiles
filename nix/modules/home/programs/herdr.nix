{ config, pkgs, lib, llmAgentPkgs, ... }:

{
  home.packages = [
    llmAgentPkgs.herdr
  ];

  # Herdr saves onboarding and settings-menu choices into config.toml, so link
  # the working-tree file to keep it writable. Only the file is linked because
  # Herdr also keeps logs, sockets, and session state in ~/.config/herdr.
  xdg.configFile."herdr/config.toml".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/herdr/config.toml";
}
