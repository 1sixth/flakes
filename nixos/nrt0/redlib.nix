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
      package = pkgs.redlib.overrideAttrs (old: rec {
        src = pkgs.fetchFromGitHub {
          owner = "redlib-org";
          repo = "redlib";
          rev = "d3ba5f3efb6825f4b0454523dae472b2adda3066";
          hash = "sha256-XT6I7EvSPY2KdKTeJyLQ2tu6iiXipy5PB4OgyEsrMhM=";
        };
        cargoDeps = old.cargoDeps.overrideAttrs {
          inherit src;
          outputHash = "sha256-6a//gKo4YYsXdf5mxktD3gmeoUdKujUPUUO9EOnf8ao=";
        };
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
      "REDLIB_DEFAULT_SHOW_NSFW" = "on";
      "REDLIB_DEFAULT_USE_HLS" = "on";
      "REDLIB_DEFAULT_DISABLE_VISIT_REDDIT_CONFIRMATION" = "on";
    };
    serviceConfig = {
      ExecStart = lib.mkForce (
        "${config.programs.proxychains.package}/bin/proxychains4 -q "
        + "${config.services.redlib.package}/bin/redlib --address 127.0.0.1 --port 8001"
      );
      RuntimeMaxSec = "1h";
    };
  };
}
