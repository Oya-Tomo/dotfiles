{ config, pkgs, lib, ... }:

let
  sharedInstructions = ./../../../../agents/shared-instructions.md;
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
    ".claude/CLAUDE.md".source = sharedInstructions;
    ".claude/statusline-command.sh".source = ./../../../../claude/statusline-command.sh;
    ".claude/claude-notify.sh".source = ./../../../../claude/claude-notify.sh;
    ".claude/channels/discord/access.json".source = ./../../../../claude/channels/discord/access.json;
    ".codex/AGENTS.md".source = sharedInstructions;
    ".agents/skills".source = sharedSkills;
    ".claude/skills".source = config.home.file.".agents/skills".source;
  } // codexSkillLinks;
}
