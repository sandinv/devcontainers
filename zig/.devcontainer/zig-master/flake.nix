{
  description = "Zig and ZLS from master";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    zig-overlay.url = "github:mitchellh/zig-overlay";
  };

  outputs = { self, nixpkgs, flake-utils, zig-overlay }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ zig-overlay.overlays.default ];
        };
        zig = pkgs.zigpkgs.master;

        zls-src = pkgs.fetchFromGitHub {
          owner = "zigtools";
          repo = "zls";
          rev = "99eaaf61abf3dc35c6c6c49e3459b632eeda3dfe";
          sha256 = "sha256-siRiMBlRfHySRhwzenUp93oPm1l0ZgJ9sJ8dd/kXITk=";
          # You can pin a commit and add sha256 for reproducibility
          # rev = "somecommit";
          # sha256 = "sha256-value";
        };
      in {
        packages = {
          zig-master = zig;

          zls = pkgs.stdenv.mkDerivation {
            pname = "zls";
            version = "master";

            src = zls-src;

            nativeBuildInputs = [ zig ];

            buildPhase = ''
              export ZIG_GLOBAL_CACHE_DIR=$TMPDIR/zig-cache
              zig build -Doptimize=ReleaseFast
            '';

            installPhase = ''
              mkdir -p $out/bin
              cp zig-out/bin/zls $out/bin/
            '';
          };

          default = pkgs.zigpkgs.master;
        };
      });
}
