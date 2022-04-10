{ config, ... }:

{
  services = {
    nginx.virtualHosts."${config.networking.hostName}.9875321.xyz".extraConfig = "include ${config.sops.secrets."nginx/v2ray.conf".path};";
    v2ray = {
      configFile = "${config.sops.secrets."v2ray.json".path}";
      enable = true;
    };
  };

  sops.secrets = {
    "nginx/v2ray.conf" = {
      owner = config.users.users.nginx.name;
      group = config.users.users.nginx.group;
    };
    "v2ray.json" = { };
  };
}
