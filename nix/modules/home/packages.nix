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
    uv
    nodejs_24
    bun
    rustc
    cargo

    # Neovim deps
    gcc
    tree-sitter

    # Other
    tailscale
    ffmpeg
    typst
    claude-code
    libnotify
    xclip
    xdotool
    openscad
  ];
}
