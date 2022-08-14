{ config, lib, ... }:

{
  services = {
    traefik.dynamicConfigOptions.http = {
      routers = {
        vaultwarden = {
          rule = "Host(`vault.shinta.ro`)";
          service = "vaultwarden";
        };
        vaultwarden-websocket = {
          rule = "Host(`vault.shinta.ro`) && Path(`/notifications/hub`)";
          service = "vaultwarden-websocket";
        };
      };
      services = {
        vaultwarden.loadBalancer.servers = [{ url = "http://127.0.0.1:8000"; }];
        vaultwarden-websocket.loadBalancer.servers = [{ url = "http://127.0.0.1:3012"; }];
      };
    };
    vaultwarden = {
      config.dataFolder = "/var/lib/vaultwarden";
      enable = true;
      environmentFile = config.sops.secrets.vaultwarden.path;
    };
  };

  sops.secrets.vaultwarden.restartUnits = [ "vaultwarden.service" ];

  systemd.services.vaultwarden.serviceConfig.StateDirectory = lib.mkForce "vaultwarden";
}
