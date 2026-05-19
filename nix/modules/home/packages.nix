{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    # CLI tools
    ripgrep
    fd
    bat
    eza
    jq
    fzf
    delta
    tokei
    dust
    hyperfine
    gh
    unzip
    zip
    curl
    wget

    # Languages (global defaults)
    python312
    nodejs_24
    rustc
    cargo

    # Neovim deps
    gcc
    tree-sitter

    # Other
    tailscale
    ffmpeg
  ];
}
