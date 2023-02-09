{ config, pkgs, ... }:

{
  services.traefik.dynamicConfigOptions.http = {
    routers.sing-box = {
      rule = "Host(`${config.networking.hostName}.9875321.xyz`, `${config.networking.hostName}-cf.9875321.xyz`) && Path(`/websocket`)";
      service = "sing-box";
    };
    services.sing-box.loadBalancer.servers = [{
      url = "http://127.0.0.1:10000";
    }];
  };

  sops.secrets."sing-box.json" = {
    restartUnits = [ "sing-box.service" ];
    sopsFile = ./secrets.yaml;
  };

  # https://github.com/SagerNet/sing-box/blob/66d8d563eba3914280b5b4283603c20f3c5d0889/release/local/sing-box.service
  systemd.services.sing-box = {
    description = "sing-box service";
    documentation = [ "https://sing-box.sagernet.org" ];
    after = [ "network.target" "nss-lookup.target" ];
    serviceConfig = {
      WorkingDirectory = "/var/lib/sing-box/";
      CapabilityBoundingSet = [ "CAP_NET_ADMIN" "CAP_NET_BIND_SERVICE" ];
      AmbientCapabilities = [ "CAP_NET_ADMIN" "CAP_NET_BIND_SERVICE" ];
      ExecStart = "${pkgs.sing-box}/bin/sing-box run -c /run/credentials/sing-box.service/sing-box.json";
      Restart = "on-failure";
      RestartSec = "10s";
      LimitNOFILE = "infinity";
      DynamicUser = true;
      StateDirectory = "sing-box";
      LoadCredential = "sing-box.json:${config.sops.secrets."sing-box.json".path}";
    };
    wantedBy = [ "multi-user.target" ];
  };
}
