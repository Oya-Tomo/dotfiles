{ ... }:

{
  # The host package manager installs zsh itself. Home Manager only deploys
  # the user configuration and keeps all zsh-specific files under zsh/.
  programs.zsh.enable = false;

  programs.starship.enableZshIntegration = false;
  programs.direnv.enableZshIntegration = false;
  programs.wezterm.enableZshIntegration = false;
  programs.lazygit.enableZshIntegration = false;

  home.file.".zshenv".source = ./../../../../zsh/.zshenv;

  xdg.configFile = {
    "zsh/.zprofile".source = ./../../../../zsh/.zprofile;
    "zsh/.zshrc".source = ./../../../../zsh/.zshrc;
  };
}
