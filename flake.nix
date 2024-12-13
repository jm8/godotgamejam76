{
  description = "A devShell example";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    nixgl.url = "github:nix-community/nixGL";
  };

  outputs = {
    self,
    nixpkgs,
    nixgl,
    flake-utils,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        godot_wrap_overlay = final: prev: {
          godot_4 = pkgs.writeShellScriptBin "godot4" ''
            exec ${prev.nixgl.auto.nixGLDefault}/bin/nixGL ${prev.godot_4}/bin/godot4 "$@"
          '';
        };
        overlays = [nixgl.overlay godot_wrap_overlay];
        pkgs = import nixpkgs {
          inherit system overlays;
        };
      in {
        devShells.default = pkgs.mkShell {
          nativeBuildInputs = [
            pkgs.nixgl.auto.nixGLDefault
            pkgs.godot_4
          ];
        };
      }
    );
}
