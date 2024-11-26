{ config, lib, ... }:

{
  services = {
    nginx.enable = lib.mkForce false;
    tailscale.derper = {
      domain = "${config.networking.hostName}.9875321.xyz";
      enable = true;
    };
    traefik = {
      dynamicConfigOptions.http = {
        routers.derp = {
          rule = "Host(`${config.services.tailscale.derper.domain}`)";
          service = "derp";
        };
        services.derp.loadBalancer.servers = [
          { url = "http://127.0.0.1:8010"; }
        ];
      };
    };
  };

  # force derper to listen on 127.0.0.1, also disable STUN
  systemd.services.tailscale-derper.serviceConfig.ExecStart = lib.mkForce (
    "${config.services.tailscale.package.derper}/bin/derper -a 127.0.0.1:8010 -c /var/lib/derper/derper.key "
    + "-hostname=${config.services.tailscale.derper.domain} -stun=false -verify-clients"
  );
}
