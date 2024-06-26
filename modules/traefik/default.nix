{ config, ... }:

{
  security.acme = {
    acceptTerms = true;
    certs."9875321.xyz" = {
      domain = "${config.networking.hostName}.9875321.xyz";
      extraDomainNames = [ "${config.networking.hostName}-cf.9875321.xyz" ];
    };
    defaults = {
      dnsProvider = "cloudflare";
      email = "acme@shinta.ro";
      environmentFile = config.sops.secrets.cloudflare_token.path;
      reloadServices = [ "traefik.service" ];
    };
  };

  services.traefik = {
    dynamicConfigOptions = {
      middlewares.compress.compress = { };
      tls = {
        certificates = [
          {
            certFile = "/run/credentials/traefik.service/9875321.xyz.crt";
            keyFile = "/run/credentials/traefik.service/9875321.xyz.key";
          }
        ];
        options.default = {
          minVersion = "VersionTLS12";
          sniStrict = true;
        };
      };
    };
    enable = true;
    staticConfigOptions = {
      entryPoints = {
        http = {
          address = ":80";
          http.redirections.entryPoint.to = "https";
        };
        https = {
          address = ":443";
          http.tls = { };
          http3 = { };
        };
      };
    };
  };

  sops.secrets.cloudflare_token = {
    sopsFile = ./secrets.yaml;
    owner = config.users.users.acme.name;
    group = config.users.users.acme.group;
  };

  systemd.services.traefik.serviceConfig.LoadCredential = [
    "9875321.xyz.crt:${config.security.acme.certs."9875321.xyz".directory}/cert.pem"
    "9875321.xyz.key:${config.security.acme.certs."9875321.xyz".directory}/key.pem"
  ];
}
