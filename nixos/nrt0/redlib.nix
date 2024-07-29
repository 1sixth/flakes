{
  config,
  lib,
  pkgs,
  ...
}:

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
    redlib = {
      enable = true;
      # To be removed in the next version.
      package = pkgs.redlib.overrideAttrs (old: {
        patches = (old.patches or [ ]) ++ [
          (pkgs.fetchpatch {
            url = "https://github.com/redlib-org/redlib/commit/67a890cab30e899650d40aa5c3d5416d3958c723.diff";
            hash = "sha256-Mj825a4iScpXqA72WmZUmUlFqrlyIQSDusgc6zWo7h4=";
          })
        ];
      });
    };
    traefik = {
      dynamicConfigOptions.http = {
        routers.redlib = {
          rule = "Host(`reddit.shinta.ro`)";
          service = "redlib";
        };
        services.redlib.loadBalancer.servers = [ { url = "http://127.0.0.1:8001"; } ];
      };
    };
  };

  systemd.services.redlib = {
    environment = {
      "LIBREDDIT_DEFAULT_SHOW_NSFW" = "on";
      "LIBREDDIT_DEFAULT_USE_HLS" = "on";
      "LIBREDDIT_DEFAULT_DISABLE_VISIT_REDDIT_CONFIRMATION" = "on";
    };
    serviceConfig.ExecStart = lib.mkForce (
      "${config.programs.proxychains.package}/bin/proxychains4 -q "
      + "${config.services.redlib.package}/bin/redlib --address 127.0.0.1 --port 8001"
    );
  };
}
