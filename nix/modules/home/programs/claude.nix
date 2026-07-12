{ config, pkgs, lib, ... }:

let
  sharedSkills = ./../../../../agents/skills;
  codexSkillLinks = lib.mapAttrs' (
    name: _: lib.nameValuePair ".codex/skills/${name}" {
      source = sharedSkills + "/${name}";
    }
  ) (lib.filterAttrs (_: type: type == "directory") (builtins.readDir sharedSkills));
in
{
  home.file = {
    ".claude/settings.json".source = ./../../../../claude/settings.json;
    ".claude/settings.local.json".source = ./../../../../claude/settings.local.json;
    ".claude/statusline-command.sh".source = ./../../../../claude/statusline-command.sh;
    ".claude/claude-notify.sh".source = ./../../../../claude/claude-notify.sh;
    ".claude/channels/discord/access.json".source = ./../../../../claude/channels/discord/access.json;
    ".agents/skills".source = sharedSkills;
    ".claude/skills".source = config.home.file.".agents/skills".source;
  } // codexSkillLinks;
}
