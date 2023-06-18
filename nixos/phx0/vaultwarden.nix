{ config, lib, ... }:

{
  services = {
    postgresql = {
      ensureDatabases = [ "vaultwarden" ];
      ensureUsers = [{
        name = "vaultwarden";
        ensurePermissions = {
          "DATABASE vaultwarden" = "ALL PRIVILEGES";
        };
      }];
    };
    traefik.dynamicConfigOptions.http = {
      routers.vaultwarden = {
        rule = "Host(`vault.shinta.ro`)";
        service = "vaultwarden";
      };
      services.vaultwarden.loadBalancer.servers = [{ url = "http://127.0.0.1:${builtins.toString config.services.vaultwarden.config.ROCKET_PORT}"; }];
    };
    vaultwarden = {
      config.ROCKET_PORT = 8003;
      dbBackend = "postgresql";
      enable = true;
      environmentFile = config.sops.secrets.vaultwarden.path;
    };
  };

  sops.secrets.vaultwarden.restartUnits = [ "vaultwarden.service" ];

  systemd.services.vaultwarden.serviceConfig.StateDirectory = lib.mkForce "vaultwarden";
}
