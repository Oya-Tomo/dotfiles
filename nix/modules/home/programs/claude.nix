{ config, pkgs, lib, ... }:

{
  home.file = {
    ".claude/settings.json".source = ./../../../../claude/settings.json;
    ".claude/settings.local.json".source = ./../../../../claude/settings.local.json;
    ".claude/statusline-command.sh".source = ./../../../../claude/statusline-command.sh;
    ".claude/channels/discord/access.json".source = ./../../../../claude/channels/discord/access.json;
    ".agents/skills".source = ./../../../../agents/skills;
    ".claude/skills".source = config.home.file.".agents/skills".source;
  };
}
