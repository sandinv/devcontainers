{
  description = "Zig from master";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    zig-overlay.url = "github:mitchellh/zig-overlay";
  };

  outputs = { self, nixpkgs, zig-overlay }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ zig-overlay.overlays.default ];
      };
    in {
      packages.${system}.zig-master = pkgs.master;
    };
}
