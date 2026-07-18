# Visual Studio Code

Visual Studio Code is installed and configured through Home Manager. The Nix
module manages the editor package, extensions, and the `nixfmt` and `rustfmt`
formatter executables.

## Configuration

Global user settings are stored in [`settings.json`](settings.json). Home
Manager uses `mkOutOfStoreSymlink` to link the file to:

```text
~/.config/Code/User/settings.json -> ~/dotfiles/vscode/settings.json
```

The link remains writable, so changes made through the Visual Studio Code
Settings UI update the tracked `settings.json` file directly. It assumes this
repository is checked out at `~/dotfiles`.

## Packages and Extensions

The editor package, formatter packages, and extension list are maintained in
`nix/modules/home/programs/vscode.nix`. Extensions available from nixpkgs use
`pkgs.vscode-extensions`; extensions missing from nixpkgs are fetched from the
Visual Studio Marketplace with a fixed version and hash.

Visual Studio Code and extension self-updates are disabled in `settings.json`.
Update the editor and nixpkgs-backed extensions through the flake inputs.
Marketplace extensions require a manual version and hash update in
`vscode.nix`.

Apply changes with:

```bash
nix run home-manager -- switch --flake ~/dotfiles
```
