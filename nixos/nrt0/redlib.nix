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
          rev = "793047f63f0f603e342c919bbfc469c7569276fa";
          hash = "sha256-A6t/AdKP3fCEyIo8fTIirZAlZPfyS8ba3Pejp8J6AUQ=";
        };
        cargoDeps = old.cargoDeps.overrideAttrs {
          inherit src;
          outputHash = "sha256-rJXKH9z8DC+7qqawbnSkYoQby6hBLLM6in239Wc8rvk=";
        };
        checkFlags = [ old.checkFlags or [ ] ] ++ [ "--skip=test_gated_and_quarantined" ];
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
