{ config, ... }:

{
  services.nginx.virtualHosts."${config.networking.hostName}.9875321.xyz".locations = {
    "= /share".return = "301 $request_uri/";
    "/share/" = {
      basicAuthFile = config.sops.secrets.basic_auth.path;
      extraConfig = "include ${config.sops.secrets."nginx/share.conf".path};";
    };
  };

  sops.secrets = {
    basic_auth = {
      owner = config.users.users.nginx.name;
      inherit (config.users.users.nginx) group;
    };
    "nginx/share.conf" = {
      owner = config.users.users.nginx.name;
      inherit (config.users.users.nginx) group;
    };
  };
}
