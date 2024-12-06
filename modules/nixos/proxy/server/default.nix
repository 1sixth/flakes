{ config, pkgs, ... }:

{
  services.traefik.dynamicConfigOptions.http = {
    routers.sing-box = {
      rule = "(Host(`${config.networking.hostName}.9875321.xyz`) || Host(`${config.networking.hostName}-cf.9875321.xyz`)) && Path(`/proxy`)";
      service = "sing-box";
    };
    services.sing-box.loadBalancer.servers = [ { url = "http://127.0.0.1:10000"; } ];
  };

  sops.secrets = {
    "misc.json" = {
      restartUnits = [ "sing-box.service" ];
      sopsFile = ./secrets.yaml;
    };
    "route_head.json" = {
      restartUnits = [ "sing-box.service" ];
      sopsFile = ./secrets.yaml;
    };
    "route_tail.json" = {
      restartUnits = [ "sing-box.service" ];
      sopsFile = ./secrets.yaml;
    };
    "sing-box.json".restartUnits = [ "sing-box.service" ];
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
          "00-misc.json:${config.sops.secrets."misc.json".path}"
          "01-route_head.json:${config.sops.secrets."route_head.json".path}"
          "02-sing-box.json:${config.sops.secrets."sing-box.json".path}"
          "03-route_tail.json:${config.sops.secrets."route_tail.json".path}"
        ];
        StateDirectory = "sing-box";
        WorkingDirectory = "/var/lib/sing-box";
      };
      wantedBy = [ "multi-user.target" ];
    };
  };
}
