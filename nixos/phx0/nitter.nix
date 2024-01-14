{ config, ... }:

{
  services = {
    nitter = {
      enable = true;
      preferences = {
        hlsPlayback = true;
        infiniteScroll = true;
        replaceReddit = "reddit.shinta.ro";
        replaceTwitter = config.services.nitter.server.hostname;
        theme = "Auto (Twitter)";
      };
      server = {
        address = "127.0.0.1";
        hostname = "twitter.shinta.ro";
        https = true;
        port = 8002;
      };
    };
    traefik = {
      dynamicConfigOptions.http = {
        routers.nitter = {
          rule = "Host(`${config.services.nitter.server.hostname}`)";
          service = "nitter";
        };
        services.nitter.loadBalancer.servers = [{ url = "http://${config.services.nitter.server.address}:${builtins.toString config.services.nitter.server.port}"; }];
      };
    };
  };
}
