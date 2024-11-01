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
      package = pkgs.redlib.overrideAttrs (old: rec {
        src = pkgs.fetchFromGitHub {
          owner = "redlib-org";
          repo = "redlib";
          rev = "d17d097b12b227f2e783a05cbd1e37c80f9ebe0b";
          hash = "sha256-MT1FtRszFQuUMGaM4t0Zw+xOeMnK+kvG69SdyAbFB0A=";
        };
        cargoDeps = old.cargoDeps.overrideAttrs {
          inherit src;
          outputHash = "sha256-SCsxVu3n0/w6y1EYUiDgweDMEJLYEy5HOfIp70dqynM=";
        };
        checkFlags =
          [ old.checkFlags or [ ] ]
          ++ [
            "--skip=test_oauth_headers_len"
            "--skip=test_private_sub"
            "--skip=test_banned_sub"
            "--skip=test_gated_sub"
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
