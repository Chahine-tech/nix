# CI/CD configuration
{ pkgs ? import <nixpkgs> {} }:

let
  # Import flake outputs
  flake = builtins.getFlake (toString ../.);
  
  # Get packages for the current system
  packages = flake.packages.${pkgs.system};

  # Define CI jobs
  jobs = {
    build-all = pkgs.writeShellScriptBin "build-all" ''
      echo "Building all services..."
      nix build ..#api
      nix build ..#metrics
      nix build ..#worker
    '';

    build-containers = pkgs.writeShellScriptBin "build-containers" ''
      echo "Building all containers..."
      nix build ..#containers.api
      nix build ..#containers.metrics
      nix build ..#containers.worker
    '';

    test-all = pkgs.writeShellScriptBin "test-all" ''
      echo "Running all tests..."
      cd ../apps/api && go test ./...
      cd ../apps/metrics && go test ./...
      cd ../apps/worker && go test ./...
      cd ../pkg && go test ./...
    '';
  };
in jobs 