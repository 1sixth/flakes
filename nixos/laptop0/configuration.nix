{
  config,
  pkgs,
  ...
}:

{
  imports = [ ./hardware.nix ];

  boot.kernelModules = [
    # https://forums.developer.nvidia.com/t/550-54-14-cannot-create-sg-table-for-nvkmskapimemory-spammed-when-launching-chrome-on-wayland/284775/15
    "i915"
    # https://github.com/ollama/ollama/blob/main/docs/gpu.md#laptop-suspend-resume
    "nvidia_uvm"
  ];

  environment.persistence."/persistent/impermanence".users.one6th.directories = [
    ".config/Mumble"
    ".local/share/Mumble"
    ".local/share/PrismLauncher"
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
