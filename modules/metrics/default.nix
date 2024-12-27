# Metrics service module
{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.myapp.metrics;
in {
  options.services.myapp.metrics = {
    enable = mkEnableOption "Metrics service";

    port = mkOption {
      type = types.port;
      default = 8081;
      description = "Port to listen on";
    };

    logLevel = mkOption {
      type = types.enum [ "debug" "info" "warn" "error" ];
      default = "info";
      description = "Logging level";
    };

    prometheus = {
      enable = mkEnableOption "Prometheus metrics";
      port = mkOption {
        type = types.port;
        default = 9090;
        description = "Prometheus metrics port";
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.metrics = {
      description = "Metrics Service";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      serviceConfig = {
        ExecStart = "${cfg.package}/bin/metrics";
        Restart = "always";
        User = "metrics";
        Environment = [
          "PORT=${toString cfg.port}"
          "LOG_LEVEL=${cfg.logLevel}"
          "PROMETHEUS_ENABLED=${toString cfg.prometheus.enable}"
          "PROMETHEUS_PORT=${toString cfg.prometheus.port}"
        ];
      };
    };

    users.users.metrics = {
      isSystemUser = true;
      group = "metrics";
      description = "Metrics service user";
    };

    users.groups.metrics = {};
  };
} 