{
  description = "Go Microservices with Nix";

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
            air # For hot reload
          ];

          shellHook = ''
            echo "Go development environment ready!"
          '';
        };

        packages = {
          api = pkgs.buildGoModule {
            pname = "api";
            version = "0.1.0";
            src = ./apps/api;
            vendorSha256 = null;
            preBuild = ''
              ln -s ${./pkg} pkg
            '';
          };

          metrics = pkgs.buildGoModule {
            pname = "metrics";
            version = "0.1.0";
            src = ./apps/metrics;
            vendorSha256 = null;
            preBuild = ''
              ln -s ${./pkg} pkg
            '';
          };

          worker = pkgs.buildGoModule {
            pname = "worker";
            version = "0.1.0";
            src = ./apps/worker;
            vendorSha256 = null;
            preBuild = ''
              ln -s ${./pkg} pkg
            '';
          };

          default = self.packages.${system}.api;
        };

        apps = {
          api = {
            type = "app";
            program = "${self.packages.${system}.api}/bin/api";
          };

          metrics = {
            type = "app";
            program = "${self.packages.${system}.metrics}/bin/metrics";
          };

          worker = {
            type = "app";
            program = "${self.packages.${system}.worker}/bin/worker";
          };

          default = self.apps.${system}.api;
        };
      }
    );
}