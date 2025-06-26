{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs@{ flake-parts, ... }: flake-parts.lib.mkFlake { inherit inputs; } ({ lib, ... }: {

    imports = [ flake-parts.flakeModules.easyOverlay ];
    systems = lib.systems.flakeExposed;

    perSystem = { config, pkgs, ... }: {
      overlayAttrs = {
        gemini-cli = config.packages.gemini-cli;
      };

      packages = {
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
          dontCheckForBrokenSymlinks = true;
        };
      };

      defaultPackage = config.packages.gemini-cli;
    };
  });
}
