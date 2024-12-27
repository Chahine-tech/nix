# API service module
{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.myapp.api;
in {
  options.services.myapp.api = {
    enable = mkEnableOption "API service";

    port = mkOption {
      type = types.port;
      default = 8080;
      description = "Port to listen on";
    };

    logLevel = mkOption {
      type = types.enum [ "debug" "info" "warn" "error" ];
      default = "info";
      description = "Logging level";
    };
  };

  config = mkIf cfg.enable {
    systemd.services.api = {
      description = "API Service";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      serviceConfig = {
        ExecStart = "${cfg.package}/bin/api";
        Restart = "always";
        User = "api";
        Environment = [
          "PORT=${toString cfg.port}"
          "LOG_LEVEL=${cfg.logLevel}"
        ];
      };
    };

    users.users.api = {
      isSystemUser = true;
      group = "api";
      description = "API service user";
    };

    users.groups.api = {};
  };
} 