{ config, ... }:

{
  imports = [ ./hardware.nix ];

  deployment.tags = [ "china" ];

  environment.persistence."/persistent/impermanence".users.one6th.directories = [
    ".m2"
  ];

  home-manager.users.one6th = import ./home.nix;

  networking.hostName = "laptop1";

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
