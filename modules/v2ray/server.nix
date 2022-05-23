{ config, ... }:

{
  services = {
    traefik.dynamicConfigOptions.http = {
      routers.v2ray = {
        rule = "Host(`${config.networking.fqdn}`) && Path(`/ping`)";
        service = "v2ray";
      };
      services.v2ray.loadBalancer.servers = [{
        url = "http://127.0.0.1:10000";
      }];
    };
    v2ray = {
      configFile = config.sops.templates."v2ray.json".path;
      enable = true;
    };
  };

  sops = {
    secrets."v2ray_id".restartUnits = [ "v2ray.service" ];
    templates."v2ray.json".content = builtins.toJSON {
      inbounds = [{
        listen = "127.0.0.1";
        port = 10000;
        protocol = "vless";
        settings = { clients = [{ id = config.sops.placeholder."v2ray_id"; }]; decryption = "none"; };
        sniffing.enabled = true;
        streamSettings = { network = "ws"; wsSettings.path = "/ping"; };
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

          { protocol = [ "bittorrent" ]; outboundTag = "BLOCK"; type = "field"; }
          { domain = [ "category-ads" ]; outboundTag = "BLOCK"; type = "field"; }

          { domain = [ "geosite:google" "geosite:netflix" ]; outboundTag = "IPv4"; type = "field"; }
        ];
      };
    };
  };
}
