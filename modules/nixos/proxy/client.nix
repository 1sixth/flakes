{ pkgs, ... }:

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

  sops.secrets."sing-box.json" = {
    path = "/etc/sing-box/config.json";
    restartUnits = [ "sing-box.service" ];
  };

  systemd = {
    packages = [ pkgs.sing-box ];
    services.sing-box = {
      serviceConfig = {
        DynamicUser = "yes";
        StateDirectory = "sing-box";
      };
      wantedBy = [ "multi-user.target" ];
    };
  };
}
