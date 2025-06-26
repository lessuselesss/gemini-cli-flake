{
  description = "A flake for gemini-cli";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in
    {
      packages.${system}.gemini-cli = pkgs.stdenv.mkDerivation {
        pname = "gemini-cli";
        version = "1.0.0";
        src = ./.;
        installPhase = ''
          mkdir -p $out/bin
          cp gemini-cli $out/bin/gemini-cli
          chmod +x $out/bin/gemini-cli
        '';
      };

      # Define the 'app'
      apps.${system}.gemini-cli = {
        type = "app";
        program = "${self.packages.${system}.gemini-cli}/bin/gemini-cli";
      };

      # Optionally, defaultPackage and defaultApp for convenience
      defaultPackage.${system} = self.packages.${system}.gemini-cli;
      defaultApp.${system} = self.apps.${system}.gemini-cli;
    };
}
