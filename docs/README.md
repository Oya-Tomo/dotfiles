# Docs

Tips and troubleshooting guides for running Nix-managed tools on non-NixOS systems.

## Guides

- [Running WezTerm on non-NixOS (Nix + NVIDIA)](run-wezterm-on-non-nixos.md) — Use home-manager's `targets.genericLinux.gpu` to make WezTerm work on Ubuntu with NVIDIA hybrid graphics. The recommended approach using `/run/opengl-driver`.

- [Show Nix-installed apps in the GNOME start menu](nix-apps-on-gnome-menu.md) — One-line fix (`targets.genericLinux.enable = true`) to make home-manager-installed applications appear in GNOME Activities.

## Archive

- [Legacy: Manual NVIDIA library wrapping](run-wezterm-on-non-nixos-legacy.md) — The previous approach using manual NVIDIA library extraction, `symlinkJoin` wrappers, and `LD_LIBRARY_PATH` injection. Replaced by `targets.genericLinux.gpu`. Kept for the technical deep-dive into Nix's dynamic linker, libglvnd vendor dispatch, and NVIDIA EGL platform mechanism.
