{ config, ... }:

{
  services.traefik = {
    dynamicConfigOptions = {
      middlewares.compress.compress = { };
      tls.options.default = {
        minVersion = "VersionTLS12";
        sniStrict = true;
      };
    };
    enable = true;
    staticConfigOptions = {
      certificatesResolvers.letsencrypt.acme = {
        dnsChallenge.provider = "cloudflare";
        email = "letsencrypt@shinta.ro";
        keyType = "EC256";
        storage = "${config.services.traefik.dataDir}/acme.json";
      };
      entryPoints = {
        http = {
          address = ":80";
          http.redirections.entryPoint.to = "https";
        };
        https = {
          address = ":443";
          http.tls.certResolver = "letsencrypt";
          http3 = { };
        };
      };
    };
  };

  sops.secrets.cloudflare_token = {
    sopsFile = ./secrets.yaml;
    owner = config.users.users.traefik.name;
    group = config.users.users.traefik.group;
  };

  systemd.services.traefik.serviceConfig.EnvironmentFile = [
    config.sops.secrets.cloudflare_token.path
  ];
}
