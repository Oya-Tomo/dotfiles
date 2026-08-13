{ config, pkgs, lib, llmAgentPkgs, ... }:

{
  home.packages = (with pkgs; [
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

    # Kubernetes
    kubectl

    # Other
    tailscale
    ffmpeg
    typst
    libnotify
    xclip
    xdotool
    openscad

    # Fonts
    nerd-fonts.hack
  ]) ++ [
    llmAgentPkgs.claude-code
    llmAgentPkgs.codex
  ];
}
