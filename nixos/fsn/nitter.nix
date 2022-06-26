{ config, ... }:

{
  services = {
    nitter = {
      enable = true;
      preferences = {
        replaceTwitter = config.services.nitter.server.hostname;
        theme = "Auto";
      };
      server = {
        address = "127.0.0.1";
        https = true;
        hostname = "twitter.shinta.ro";
        port = 8082;
      };
    };
    traefik = {
      dynamicConfigOptions.http = {
        routers.nitter = {
          rule = "Host(`twitter.shinta.ro`)";
          service = "nitter";
        };
        services.nitter.loadBalancer.servers = [{ url = "http://${config.services.nitter.server.address}:${builtins.toString config.services.nitter.server.port}"; }];
      };
    };
  };
}
