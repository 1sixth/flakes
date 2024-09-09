{ config, ... }:

{
  services = {
    prometheus.exporters.node = {
      disabledCollectors = [ "arp" ];
      enabledCollectors = [ "systemd" ];
      enable = true;
      listenAddress = "127.0.0.1";
      port = 9100;
    };
    traefik.dynamicConfigOptions.http = {
      middlewares.prometheus-basic-auth.basicAuth.usersFile =
        config.sops.secrets.prometheus_basic_auth.path;
      routers.metrics = {
        middlewares = [ "prometheus-basic-auth" ];
        rule = "Host(`${config.networking.hostName}.9875321.xyz`) && Path(`/metrics`)";
        service = "metrics";
      };
      services.metrics.loadBalancer.servers = [
        { url = "http://127.0.0.1:${builtins.toString config.services.prometheus.exporters.node.port}"; }
      ];
    };
  };

  sops.secrets.prometheus_basic_auth = {
    restartUnits = [ "traefik.service" ];
    sopsFile = ./secrets.yaml;
    owner = config.systemd.services.traefik.serviceConfig.User;
  };
}
