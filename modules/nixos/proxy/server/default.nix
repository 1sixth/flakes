{ config, pkgs, ... }:

{
  services.traefik.dynamicConfigOptions.http = {
    routers.sing-box = {
      rule = "(Host(`${config.networking.hostName}.9875321.xyz`) || Host(`${config.networking.hostName}-cf.9875321.xyz`)) && Path(`/proxy`)";
      service = "sing-box";
    };
    services.sing-box.loadBalancer.servers = [ { url = "http://127.0.0.1:10000"; } ];
  };

  sops.secrets."sing-box.json" = {
    restartUnits = [ "sing-box.service" ];
    sopsFile = ./secrets.yaml;
  };

  systemd = {
    packages = [ pkgs.sing-box ];
    services.sing-box = {
      serviceConfig = {
        DynamicUser = "yes";
        ExecStart = [
          ""
          "${pkgs.sing-box}/bin/sing-box -C $CREDENTIALS_DIRECTORY run"
        ];
        LoadCredential = [
          "9875321.xyz.crt:${config.security.acme.certs."9875321.xyz".directory}/cert.pem"
          "9875321.xyz.key:${config.security.acme.certs."9875321.xyz".directory}/key.pem"
          "config.json:${config.sops.secrets."sing-box.json".path}"
        ];
        StateDirectory = "sing-box";
        WorkingDirectory = "/var/lib/sing-box";
      };
      wantedBy = [ "multi-user.target" ];
    };
  };
}
