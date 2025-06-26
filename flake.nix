{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } ({ lib, pkgs, ... }: {

      imports = [
        # Imports the module that makes creating overlays simple.
        flake-parts.flakeModules.easyOverlay
      ];

      # Use the standard set of systems exposed by nixpkgs.
      systems = lib.systems.flakeExposed;

      # This block is evaluated for each system (e.g., "x86_64-linux").
      perSystem = { config, pkgs, ... }: {

        # `overlayAttrs` is where you define new or modified packages.
        # `easyOverlay` turns this into a proper Nixpkgs overlay.
        overlayAttrs = {
          gemini-cli = pkgs.buildNpmPackage {
            pname = "gemini";
            version = "0.0.1";
            src = pkgs.fetchFromGitHub {
              owner = "google-gemini";
              repo = "gemini-cli";
              rev = "0915bf7d677504c28b079693a0fe1c853adc456e";
              hash = "sha256-s1K3bNEDdqy2iz3bk/3RdaCoGDenfc6knARzO/q3YcE=";
            };
            npmDepsHash = "sha256-2zyMrVykKtN+1ePQko9MVhm79p7Xbo9q0+r/P22buQA=";
            npmPackFlags = [ "--ignore-scripts" ];
          };
        };

        # `flake-parts` automatically makes everything in `overlayAttrs` a package.
        # We just need to tell it which one is the default.
        # The `pkgs` here already includes our new `gemini-cli` from the overlay.
        packages.default = pkgs.gemini-cli;

        # You can also add other aliases if you want.
        packages.gemini = pkgs.gemini-cli;
      };
    });
}
