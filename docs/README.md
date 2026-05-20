# Docs

Tips and troubleshooting guides for running Nix-managed tools on non-NixOS systems.

## Guides

- [Running WezTerm on non-NixOS (Nix + NVIDIA)](run-wezterm-on-non-nixos.md) — How to make Nix-installed WezTerm work on Ubuntu with NVIDIA hybrid graphics. Covers EGL/libglvnd vendor selection, NVIDIA library extraction, and the failed approaches that were tried along the way.

- [Show Nix-installed apps in the GNOME start menu](nix-apps-on-gnome-menu.md) — One-line fix (`targets.genericLinux.enable = true`) to make home-manager-installed applications appear in GNOME Activities.
