{
  description = "Simple Go API";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [
            go
            gopls
            go-tools
          ];
        };

        packages.default = pkgs.buildGoModule {
          pname = "go-api";
          version = "0.1.0";
          src = ./.;
          vendorSha256 = null;
        };
      }
    );
}