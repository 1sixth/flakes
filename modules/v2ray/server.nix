{ config, ... }:

{
  services = {
    nginx.virtualHosts."${config.networking.hostName}.9875321.xyz".extraConfig = "include ${config.sops.templates."v2ray.conf".path};";
    v2ray = {
      configFile = config.sops.templates."v2ray.json".path;
      enable = true;
    };
  };

  sops = {
    secrets = {
      "v2ray/id".restartUnits = [ "v2ray.service" ];
      "v2ray/path".restartUnits = [ "v2ray.service" ];
    };
    templates = {
      "v2ray.conf" = {
        content = ''
          location ${config.sops.placeholder."v2ray/path"} {
            access_log off;
            error_log /dev/null emerg;

            proxy_pass http://127.0.0.1:10000;
            proxy_set_header Connection "upgrade";
            proxy_set_header Upgrade $http_upgrade;

            if ($http_upgrade != "websocket") {
              return 404;
            }
          }
        '';
        owner = config.users.users.nginx.name;
        inherit (config.users.users.nginx) group;
      };
      "v2ray.json".content = builtins.toJSON {
        inbounds = [{
          listen = "127.0.0.1";
          port = 10000;
          protocol = "vless";
          settings = { clients = [{ id = config.sops.placeholder."v2ray/id"; }]; decryption = "none"; };
          sniffing.enabled = true;
          streamSettings = { network = "ws"; wsSettings.path = config.sops.placeholder."v2ray/path"; };
        }];
        log.loglevel = "none";
        outbounds = [
          { protocol = "freedom"; tag = "DIRECT"; }
          { protocol = "freedom"; settings.domainStrategy = "UseIPv4"; tag = "IPv4"; }
          { protocol = "blackhole"; tag = "BLOCK"; }
        ];
        routing = {
          domainMatcher = "mph";
          domainStrategy = "IPIfNonMatch";
          rules = [
            { ip = [ "127.0.0.1" ]; network = "udp"; port = 53; outboundTag = "DIRECT"; type = "field"; }
            { ip = [ "geoip:private" ]; outboundTag = "BLOCK"; type = "field"; }

            { domain = [ "geosite:cn" ]; outboundTag = "BLOCK"; type = "field"; }
            { ip = [ "geoip:cn" ]; outboundTag = "BLOCK"; type = "field"; }

            { protocol = [ "bittorrent" ]; outboundTag = "BLOCK"; type = "field"; }
            { domain = [ "category-ads" ]; outboundTag = "BLOCK"; type = "field"; }

            { domain = [ "geosite:google" "geosite:netflix" ]; outboundTag = "IPv4"; type = "field"; }
          ];
        };
      };
    };
  };
}
