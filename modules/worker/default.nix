# Worker service module
{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.myapp.worker;
in {
  options.services.myapp.worker = {
    enable = mkEnableOption "Worker service";

    logLevel = mkOption {
      type = types.enum [ "debug" "info" "warn" "error" ];
      default = "info";
      description = "Logging level";
    };

    concurrency = mkOption {
      type = types.int;
      default = 5;
      description = "Number of concurrent workers";
    };

    interval = mkOption {
      type = types.int;
      default = 5;
      description = "Job processing interval in seconds";
    };
  };

  config = mkIf cfg.enable {
    systemd.services.worker = {
      description = "Worker Service";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      serviceConfig = {
        ExecStart = "${cfg.package}/bin/worker";
        Restart = "always";
        User = "worker";
        Environment = [
          "LOG_LEVEL=${cfg.logLevel}"
          "WORKER_CONCURRENCY=${toString cfg.concurrency}"
          "WORKER_INTERVAL=${toString cfg.interval}"
        ];
      };
    };

    users.users.worker = {
      isSystemUser = true;
      group = "worker";
      description = "Worker service user";
    };

    users.groups.worker = {};
  };
} 