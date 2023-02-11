{ config, ... }:

{
  networking.proxy.default = "http://127.0.0.1:1081";

  services.v2ray = {
    configFile = "/run/credentials/v2ray.service/v2ray.json";
    enable = true;
  };

  sops.secrets."v2ray.json".restartUnits = [ "v2ray.service" ];

  systemd.services.v2ray.serviceConfig.LoadCredential = "v2ray.json:${config.sops.secrets."v2ray.json".path}";
}
