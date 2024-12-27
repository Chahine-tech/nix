{
  description = "Go microservices with Nix";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };

        # Common Go package builder
        buildGoService = { name, src }: pkgs.buildGoModule {
          pname = name;
          version = "0.1.0";
          inherit src;
          vendorSha256 = null; # Will be updated on first build
        };

        # Build all services
        services = {
          api = buildGoService {
            name = "api";
            src = ./apps/api;
          };
          metrics = buildGoService {
            name = "metrics";
            src = ./apps/metrics;
          };
          worker = buildGoService {
            name = "worker";
            src = ./apps/worker;
          };
        };

        # Container builder function
        mkContainer = { name, port ? null, pkg }: pkgs.dockerTools.buildImage {
          inherit name;
          tag = "latest";
          copyToRoot = pkgs.buildEnv {
            name = "image-root";
            paths = [ pkg ];
            pathsToLink = [ "/bin" ];
          };
          config = {
            Cmd = [ "/bin/${name}" ];
            ExposedPorts = if port != null 
              then { "${toString port}/tcp" = {}; }
              else {};
          };
        };

      in {
        # Development shell
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            go_1_21
            gopls
            go-tools
            air # Hot reload
          ];
        };

        # Packages
        packages = services // {
          # Container images
          containers = {
            api = mkContainer {
              name = "api";
              port = 8080;
              pkg = services.api;
            };
            metrics = mkContainer {
              name = "metrics";
              port = 8081;
              pkg = services.metrics;
            };
            worker = mkContainer {
              name = "worker";
              pkg = services.worker;
            };
          };
        };

        # NixOS modules
        nixosModules.default = import ./modules;
      }
    );
}