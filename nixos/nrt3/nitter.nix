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
        port = 8001;
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
