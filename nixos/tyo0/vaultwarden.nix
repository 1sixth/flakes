{ config, lib, ... }:

{
  services = {
    traefik.dynamicConfigOptions.http = {
      routers.vaultwarden = {
        rule = "Host(`vault.shinta.ro`)";
        service = "vaultwarden";
      };
      services.vaultwarden.loadBalancer.servers = [{ url = "http://127.0.0.1:8000"; }];
    };
    vaultwarden = {
      config.dataFolder = "/var/lib/vaultwarden";
      # TODO: preStart:
      # createuser vaultwarden
      # createdb -O vaultwarden vaultwarden
      dbBackend = "postgresql";
      enable = true;
      environmentFile = config.sops.secrets.vaultwarden.path;
    };
  };

  sops.secrets.vaultwarden.restartUnits = [ "vaultwarden.service" ];

  systemd.services.vaultwarden.serviceConfig.StateDirectory = lib.mkForce "vaultwarden";
}
