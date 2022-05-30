{ config, ... }:

{
  services = {
    traefik.dynamicConfigOptions.http = {
      routers = {
        v2ray-http2 = {
          rule = "Host(`${config.networking.hostName}.9875321.xyz`) && Path(`/http2`)";
          service = "v2ray-http2";
        };
        v2ray-websocket = {
          rule = "Host(`${config.networking.hostName}.9875321.xyz`, `${config.networking.hostName}-cf.9875321.xyz`) && Path(`/websocket`)";
          service = "v2ray-websocket";
        };
      };
      services = {
        v2ray-http2.loadBalancer.servers = [{
          url = "h2c://127.0.0.1:10000";
        }];
        v2ray-websocket.loadBalancer.servers = [{
          url = "http://127.0.0.1:10001";
        }];
      };
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
    templates."v2ray.json".content = builtins.toJSON {
      inbounds = [
        {
          listen = "127.0.0.1";
          port = 10000;
          protocol = "vless";
          settings = { clients = [{ id = config.sops.placeholder."v2ray_id"; }]; decryption = "none"; };
          sniffing.enabled = true;
          streamSettings = { network = "http"; httpSettings = { host = [ "${config.networking.hostName}.9875321.xyz" ]; path = "/http2"; }; };
        }
        {
          listen = "127.0.0.1";
          port = 10001;
          protocol = "vless";
          settings = { clients = [{ id = config.sops.placeholder."v2ray_id"; }]; decryption = "none"; };
          sniffing.enabled = true;
          streamSettings = { network = "ws"; wsSettings.path = "/websocket"; };
        }
      ];
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

          { protocol = [ "bittorrent" ]; outboundTag = "BLOCK"; type = "field"; }
          { domain = [ "category-ads" ]; outboundTag = "BLOCK"; type = "field"; }

          { domain = [ "geosite:google" "geosite:netflix" ]; outboundTag = "IPv4"; type = "field"; }
        ];
      };
    };
  };
}
