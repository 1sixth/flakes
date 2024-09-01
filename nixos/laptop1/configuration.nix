{
  config,
  ...
}:

{
  imports = [ ./hardware.nix ];

  home-manager.users.one6th = import ./home.nix;

  networking.hostName = "laptop1";

  services.logind = {
    powerKey = "ignore";
    suspendKey = "ignore";
    suspendKeyLongPress = "ignore";
  };

  sops = {
    defaultSopsFile = ./secrets.yaml;
    secrets = {
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
