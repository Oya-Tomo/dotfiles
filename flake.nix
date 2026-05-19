{
  description = "Oya-Tomo's dotfiles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager }:
  let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    homeConfigurations."oyatomo" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [ ./nix/modules/home ];
    };

    devShells.${system} = {
      default = pkgs.mkShell {
        packages = with pkgs; [ python312 nodejs_24 rustc cargo ];
      };

      python = pkgs.mkShell {
        packages = with pkgs; [
          (python312.withPackages (ps: with ps; [ pip virtualenv ]))
        ];
        shellHook = ''echo "Python $(python --version)"'';
      };

      node = pkgs.mkShell {
        packages = with pkgs; [
          nodejs_24
          pnpm
          typescript
        ];
        shellHook = ''echo "Node $(node --version)"'';
      };

      rust = pkgs.mkShell {
        packages = with pkgs; [
          rustc
          cargo
          rustfmt
          clippy
          rust-analyzer
        ];
        shellHook = ''echo "Rust $(rustc --version)"'';
      };
    };
  };
}
