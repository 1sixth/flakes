{ config, ... }:

{
  services = {
    # https://github.com/dani-garcia/vaultwarden/wiki/Proxy-examples
    nginx.virtualHosts."vault.shinta.ro" = {
      forceSSL = true;
      locations."/".proxyPass = "http://127.0.0.1:8000";
      useACMEHost = "shinta.ro";
    };
    vaultwarden = {
      # TODO: preStart:
      # createuser vaultwarden
      # createdb -O vaultwarden vaultwarden
      dbBackend = "postgresql";
      enable = true;
      environmentFile = config.sops.secrets.vaultwarden.path;
    };
  };

  sops.secrets.vaultwarden.restartUnits = [ "vaultwarden.service" ];
}
