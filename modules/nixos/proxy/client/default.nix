{
  config,
  lib,
  pkgs,
  ...
}:

{
  networking.proxy = {
    default = "http://127.0.0.1:1080";
    # https://minikube.sigs.k8s.io/docs/handbook/vpn_and_proxy/
    noProxy = builtins.concatStringsSep "," [
      "127.0.0.1"
      "localhost"
      "192.168.59.0/24"
      "192.168.39.0/24"
      "192.168.49.0/24"
      "10.96.0.0/12"
    ];
  };

  sops.secrets = {
    "dns.json" = {
      restartUnits = [ "sing-box.service" ];
      sopsFile = ./secrets.yaml;
    };
    "inbounds.json" = {
      restartUnits = [ "sing-box.service" ];
      sopsFile = ./secrets.yaml;
    };
    "misc.json" = {
      restartUnits = [ "sing-box.service" ];
      sopsFile = ./secrets.yaml;
    };
    "outbounds.json" = {
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
      preStart = lib.optionalString (
        !builtins.elem "server" config.deployment.tags
      ) "ln -fsT ${pkgs.metacubexd} $STATE_DIRECTORY/dashboard";
      serviceConfig = {
        DynamicUser = "yes";
        ExecStart = [
          ""
          "${pkgs.sing-box}/bin/sing-box -C $CREDENTIALS_DIRECTORY run"
        ];
        LoadCredential = [
          "00-dns.json:${config.sops.secrets."dns.json".path}"
          "01-inbounds.json:${config.sops.secrets."inbounds.json".path}"
          "02-misc.json:${config.sops.secrets."misc.json".path}"
          "03-outbounds.json:${config.sops.secrets."outbounds.json".path}"
          "04-route_head.json:${config.sops.secrets."route_head.json".path}"
          "05-sing-box.json:${config.sops.secrets."sing-box.json".path}"
          "06-route_tail.json:${config.sops.secrets."route_tail.json".path}"
        ];
        StateDirectory = "sing-box";
        WorkingDirectory = "/var/lib/sing-box";
      };
      wantedBy = [ "multi-user.target" ];
    };
  };
}
