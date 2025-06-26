{
  description = "Gemini CLI as a Nix flake package";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };

        # Set your package version and npm hash here
        version = "0.1.0";
        npmDepsHash = "sha256-0000000000000000000000000000000000000000000="; # <- Update this!

        # If your CLI is defined in node_modules/.bin/gemini or similar, you can add more here
        executables = {
          "gemini" = "bin/gemini.js"; # adjust the path if needed
        };
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            nodejs
          ];
        };

        packages = {
          default = self.packages.${system}.gemini-cli;

          "gemini-cli" = pkgs.buildNpmPackage {
            pname = "gemini";
            version = version;
            src = ./.;
            npmDepsHash = npmDepsHash;

            installPhase = ''
              runHook preInstall

              mkdir -p $out/bin $out/share
              cp -r node_modules $out/share/

              # Symlink the CLI
              ln -s $out/share/node_modules/${executables.gemini} $out/bin/gemini

              runHook postInstall
            '';
          };
        };

        apps.default = flake-utils.lib.mkApp {
          drv = self.packages.${system}.gemini-cli;
          name = "gemini";
        };
      }
    );
}
