{ config, ... }:

{
  services = {
    traefik.dynamicConfigOptions.http = {
      routers.v2ray-websocket = {
        rule = "Host(`${config.networking.hostName}.9875321.xyz`, `${config.networking.hostName}-cf.9875321.xyz`) && Path(`/websocket`)";
        service = "v2ray-websocket";
      };
      services.v2ray-websocket.loadBalancer.servers = [{
        url = "http://127.0.0.1:10000";
      }];
    };
    v2ray = {
      configFile = config.sops.templates."v2ray.json".path;
      enable = true;
    };
  };

  sops = {
    # V2ray won't restart if it's just the template that changes. And
    # there is no option to change this behavior, which is a bit inconvenient.
    secrets."v2ray_id".restartUnits = [ "v2ray.service" ];
    templates."v2ray.json" = {
      content = builtins.toJSON {
        inbounds = [{
          listen = "127.0.0.1";
          port = 10000;
          protocol = "vless";
          settings = { clients = [{ id = config.sops.placeholder."v2ray_id"; }]; decryption = "none"; };
          sniffing.enabled = true;
          streamSettings = { network = "ws"; wsSettings.path = "/websocket"; };
        }];
        log = {
          access = "none";
          error = "none";
        };
        outbounds = [
          { protocol = "freedom"; tag = "DIRECT"; }
          { protocol = "freedom"; settings.domainStrategy = "UseIPv4"; tag = "IPv4"; }
          { protocol = "blackhole"; tag = "BLOCK"; }
        ];
        routing = {
          domainMatcher = "mph";
          domainStrategy = "IPIfNonMatch";
          rules = [
            { ip = [ "geoip:private" ]; outboundTag = "BLOCK"; type = "field"; }

            { protocol = [ "bittorrent" ]; outboundTag = "BLOCK"; type = "field"; }
            { domain = [ "category-ads" ]; outboundTag = "BLOCK"; type = "field"; }

            { domain = [ "geosite:netflix" "geosite:google" "geosite:pixiv" ]; outboundTag = "IPv4"; type = "field"; }
          ];
        };
      };
      mode = "0444";
    };
  };
}
