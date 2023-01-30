{ config, ... }:

{
  services = {
    libreddit = {
      address = "127.0.0.1";
      enable = true;
      port = 8000;
    };
    traefik = {
      dynamicConfigOptions.http = {
        routers.libreddit = {
          rule = "Host(`reddit.shinta.ro`)";
          service = "libreddit";
        };
        services.libreddit.loadBalancer.servers = [{
          url = "http://${config.services.libreddit.address}:${builtins.toString config.services.libreddit.port}";
          }];
      };
    };
  };
}
