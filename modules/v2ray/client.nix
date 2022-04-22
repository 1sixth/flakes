{ config, ... }:

{
  networking.proxy.default = "http://127.0.0.1:1081";

  services.v2ray = {
    configFile = "${config.sops.secrets."v2ray.json".path}";
    enable = true;
  };

  sops.secrets."v2ray.json".restartUnits = [ "v2ray.service" ];
}
