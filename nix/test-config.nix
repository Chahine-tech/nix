# Test configuration for NixOS modules
{ pkgs ? import <nixpkgs> {} }:

let
  # Import the flake for testing
  flake = builtins.getFlake (toString ../.);
  
  # Create a minimal NixOS configuration
  testConfig = pkgs.nixosTest {
    name = "microservices-test";
    
    nodes.machine = { config, pkgs, ... }: {
      imports = [
        ../modules
      ];

      # Enable and configure services
      services.myapp = {
        api = {
          enable = true;
          port = 8080;
          logLevel = "debug";
        };

        metrics = {
          enable = true;
          port = 8081;
          logLevel = "info";
          prometheus.enable = true;
        };

        worker = {
          enable = true;
          logLevel = "info";
          concurrency = 2;
          interval = 10;
        };
      };
    };

    # Test script
    testScript = ''
      # Wait for services to start
      machine.wait_for_unit("api.service")
      machine.wait_for_unit("metrics.service")
      machine.wait_for_unit("worker.service")

      # Test API service
      machine.succeed("curl -f http://localhost:8080/health")

      # Test metrics service
      machine.succeed("curl -f http://localhost:8081/metrics")

      # Check worker logs
      machine.succeed("journalctl -u worker.service --no-pager")
    '';
  };

in {
  # Run the test
  test = testConfig;

  # Build the test VM
  vm = (testConfig.driver.node.config.system.build.vm);
} 