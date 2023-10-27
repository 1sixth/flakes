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

  systemd.services.libreddit.environment = {
    "LIBREDDIT_DEFAULT_SHOW_NSFW" = "on";
    "LIBREDDIT_DEFAULT_USE_HLS" = "on";
    "LIBREDDIT_DEFAULT_DISABLE_VISIT_REDDIT_CONFIRMATION" = "on";
  };
}
