{ config, ... }:

{
  services = {
    miniflux = {
      adminCredentialsFile = config.sops.secrets.miniflux_admin_credentials.path;
      enable = true;
      config = {
        BASE_URL = "https://rss.shinta.ro";
        HTTP_CLIENT_PROXY = "http://127.0.0.1:1080";
        LISTEN_ADDR = "127.0.0.1:8000";
      };
    };
    traefik.dynamicConfigOptions.http = {
      routers.miniflux = {
        rule = "Host(`rss.shinta.ro`)";
        service = "miniflux";
      };
      services.miniflux.loadBalancer.servers = [
        { url = "http://${config.services.miniflux.config.LISTEN_ADDR}"; }
      ];
    };
  };

  sops.secrets.miniflux_admin_credentials.restartUnits = [ "miniflux.service" ];
}
