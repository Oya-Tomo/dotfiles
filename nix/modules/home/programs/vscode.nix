{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    nixfmt
    rustfmt
  ];

  programs.vscode = {
    enable = true;
    package = pkgs.vscode;

    profiles.default.extensions = with pkgs.vscode-extensions; [
      charliermarsh.ruff
      esbenp.prettier-vscode
      jnoortheen.nix-ide
      ms-python.debugpy
      ms-python.python
      ms-python.vscode-pylance
      ms-python.vscode-python-envs
      ms-vsliveshare.vsliveshare
      myriad-dreamin.tinymist
      rust-lang.rust-analyzer
      tomoki1207.pdf
      yzane.markdown-pdf
      yzhang.markdown-all-in-one
    ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "vscode-edit-csv";
        publisher = "janisdd";
        version = "0.11.9";
        sha256 = "sha256-hbu/r3mBtb9nDZcP8kY4fBJ5ZuKwkO/kJFk1OWDIdlk=";
      }
      {
        name = "kanagawa-vscode-color-theme";
        publisher = "metaphore";
        version = "1.1.0";
        sha256 = "sha256-HjKlDzXc6HkDyNZJGK0wAdC2F6VAk3utywu0R+dI3RA=";
      }
    ];
  };

  xdg.configFile."Code/User/settings.json".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/vscode/settings.json";
}
