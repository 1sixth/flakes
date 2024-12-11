{
  config,
  pkgs,
  ...
}:

{
  imports = [ ./hardware.nix ];

  deployment.tags = [ "china" ];

  boot.kernelModules = [
    # nixpkgs/issues/334180
    "nvidia_uvm"
  ];

  hardware = {
    graphics.extraPackages = with pkgs; [
      intel-media-driver
      vpl-gpu-rt
    ];
    nvidia = {
      modesetting.enable = true;
      nvidiaSettings = false;
      open = true;
      powerManagement.enable = true;
    };
  };

  home-manager.users.one6th = import ./home.nix;

  networking.hostName = "laptop0";

  nixpkgs.config.cudaSupport = true;

  services = {
    logind = {
      suspendKey = "ignore";
      suspendKeyLongPress = "ignore";
    };
    xserver.videoDrivers = [ "nvidia" ];
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
