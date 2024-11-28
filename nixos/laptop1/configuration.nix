{ config, ... }:

{
  imports = [ ./hardware.nix ];

  deployment.tags = [ "china" ];

  environment.persistence."/persistent/impermanence".users.one6th.directories = [
    ".cache/helm"
    ".config/helm"
    ".config/remmina"
    ".local/share/DBeaverData"
    ".local/share/helm"
    ".local/share/remmina"
    ".kube"
    ".m2"
    ".minikube"
  ];

  home-manager.users.one6th = import ./home.nix;

  networking = {
    hostName = "laptop1";
    # https://minikube.sigs.k8s.io/docs/handbook/vpn_and_proxy/
    proxy.noProxy = builtins.concatStringsSep "," [
      "127.0.0.1"
      "localhost"
      "192.168.59.0/24"
      "192.168.39.0/24"
      "192.168.49.0/24"
      "10.96.0.0/12"
    ];
  };

  services = {
    logind = {
      powerKey = "ignore";
      suspendKey = "ignore";
      suspendKeyLongPress = "ignore";
    };
    smartdns.settings.hosts-file = config.sops.secrets.hosts.path;
  };

  sops = {
    defaultSopsFile = ./secrets.yaml;
    secrets = {
      "company.network" = {
        owner = "systemd-network";
        path = "/etc/systemd/network/company.network";
      };
      hosts.mode = "0444";
      password_root.neededForUsers = true;
      password_one6th.neededForUsers = true;
      u2f_keys.mode = "0444";
    };
  };

  users.users = {
    one6th.hashedPasswordFile = config.sops.secrets.password_one6th.path;
    root.hashedPasswordFile = config.sops.secrets.password_root.path;
  };
}
