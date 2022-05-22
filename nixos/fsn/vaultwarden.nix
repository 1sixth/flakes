{ config, lib, ... }:

{
  services = {
    # https://github.com/dani-garcia/vaultwarden/wiki/Proxy-examples
    nginx.virtualHosts."vault.shinta.ro" = {
      forceSSL = true;
      locations = {
        "/" = {
          proxyPass = "http://127.0.0.1:8000";
          proxyWebsockets = true;
        };
        "/notifications/hub" = {
          proxyPass = "http://127.0.0.1:3012";
          proxyWebsockets = true;
        };
        "/notifications/hub/negotiate" = {
          proxyPass = "http://127.0.0.1:8000";
          proxyWebsockets = true;
        };
      };
      useACMEHost = "shinta.ro";
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
