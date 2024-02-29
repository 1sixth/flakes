{ config, lib, pkgs, ... }:

{
  programs.proxychains = {
    enable = true;
    package = pkgs.proxychains-ng;
    proxies.default = {
      enable = true;
      host = "127.0.0.1";
      port = 1080;
      type = "socks5";
    };
  };

  services = {
    libreddit.enable = true;
    traefik = {
      dynamicConfigOptions.http = {
        routers.libreddit = {
          rule = "Host(`reddit.shinta.ro`)";
          service = "libreddit";
        };
        services.libreddit.loadBalancer.servers = [{
          url = "http://127.0.0.1:8000";
        }];
      };
    };
  };

  systemd.services.libreddit = {
    environment = {
      "LIBREDDIT_DEFAULT_SHOW_NSFW" = "on";
      "LIBREDDIT_DEFAULT_USE_HLS" = "on";
      "LIBREDDIT_DEFAULT_DISABLE_VISIT_REDDIT_CONFIRMATION" = "on";
    };
    serviceConfig.ExecStart = lib.mkForce (
      "${config.programs.proxychains.package}/bin/proxychains4 -q " +
      "${config.services.libreddit.package}/bin/libreddit --address 127.0.0.1 --port 8000"
    );
  };
}
