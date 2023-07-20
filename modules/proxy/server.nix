{ config, ... }:

{
  services = {
    traefik.dynamicConfigOptions.http = {
      routers.v2ray = {
        rule = "Host(`${config.networking.hostName}.9875321.xyz`, `${config.networking.hostName}-cf.9875321.xyz`) && Path(`/websocket`)";
        service = "v2ray";
      };
      services.v2ray.loadBalancer.servers = [{
        url = "http://127.0.0.1:10000";
      }];
    };
    v2ray = {
      configFile = "/run/credentials/v2ray.service/v2ray.json";
      enable = true;
    };
  };

  sops = {
    secrets."v2ray.json" = {
      restartUnits = [ "v2ray.service" ];
      sopsFile = ./secrets.yaml;
    };
  };

  systemd.services.v2ray.serviceConfig.LoadCredential = "v2ray.json:${config.sops.secrets."v2ray.json".path}";
}
