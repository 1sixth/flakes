{ config, lib, ... }:

{
  services = {
    nginx.enable = lib.mkForce false;
    tailscale.derper = {
      domain = "derp.shinta.ro";
      enable = true;
    };
    traefik = {
      dynamicConfigOptions.http = {
        routers.derp = {
          rule = "Host(`${config.services.tailscale.derper.domain}`)";
          service = "derp";
        };
        services.derp.loadBalancer.servers = [
          { url = "http://127.0.0.1:8000"; }
        ];
      };
    };
  };

  # force derper to listen on 127.0.0.1
  systemd.services.tailscale-derper.serviceConfig.ExecStart = lib.mkForce (
    "${config.services.tailscale.package.derper}/bin/derper -a 127.0.0.1:8000 -c /var/lib/derper/derper.key "
    + "-hostname=${config.services.tailscale.derper.domain} -verify-clients"
  );
}
