{
  inputs.zig.url = "github:mitchellh/zig-overlay";
  inputs.esp-dev.url = "github:mirrexagon/nixpkgs-esp-dev";
  inputs.nixpkgs.url = "https://channels.nixos.org/nixpkgs-unstable/nixexprs.tar.xz";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, zig, esp-dev, flake-utils, nixpkgs, ... }:
  flake-utils.lib.eachDefaultSystem
    (system:
      let
        overlays = [];
        pkgs = import nixpkgs {
          inherit system overlays;
        };
        nativeBuildInputs = [];
        buildInputs = [
          zig.packages."${system}".master
          esp-dev.packages."${system}".esp-idf-full
        ];
      in
      with pkgs;
      {
        devShells.default = mkShell {
          inherit buildInputs nativeBuildInputs;
        };
      }
    );
}
