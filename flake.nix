{
  # This section defines the dependencies of the flake.
  # Each input is a source of packages or functions that can be used in the outputs.
  inputs = {
    # The nixpkgs input provides the standard Nix package set.
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    # The flake-parts input provides a library to structure flakes.
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  # This section defines the outputs of the flake.
  # The outputs are the packages, applications, and other things that the flake provides.
  outputs = inputs@{ flake-parts, nixpkgs, ... }: flake-parts.lib.mkFlake { inherit inputs; } ({ ... }: {
    # This specifies the systems that the flake supports.
    systems = nixpkgs.lib.systems.flakeExposed;
    # This section defines the configuration for each system.
    perSystem = { pkgs, ... }: {
      # This defines a package named gemini-code.
      packages.gemini-code = pkgs.buildNpmPackage {
        pname = "gemini";
        version = "0.0.1";
        # This specifies the source of the package, which is fetched from GitHub.
        src = pkgs.fetchFromGitHub {
          owner = "google-gemini";
          repo = "gemini-cli";
          rev = "0915bf7d677504c28b079693a0fe1c853adc456e";
          hash = "sha256-s1K3bNEDdqy2iz3bk/3RdaCoGDenfc6knARzO/q3YcE=";
        };
        # This is the hash of the npm dependencies, which is used to ensure that the dependencies have not changed.
        npmDepsHash = "sha256-2zyMrVykKtN+1ePQko9MVhm79p7Xbo9q0+r/P22buQA=";
        # This specifies flags to pass to the npm pack command.
        npmPackFlags = [ "--ignore-scripts" ];

        # This is a build option that tells the build process not to check for broken symlinks.
        dontCheckForBrokenSymlinks = true;
      };
    };
  });
}
