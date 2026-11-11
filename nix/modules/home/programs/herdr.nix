{ config, pkgs, lib, llmAgentPkgs, ... }:

{
  home.packages = [
    llmAgentPkgs.herdr
  ];

  # Link the file rather than the directory: Herdr writes its logs and
  # agent-detection overrides into ~/.config/herdr at runtime.
  xdg.configFile."herdr/config.toml".source = ./../../../../herdr/config.toml;
}
