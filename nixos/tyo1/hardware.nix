{ modulesPath, ... }:

{
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];

  boot = {
    initrd.kernelModules = [ "nvme" ];
    loader.grub = {
      efiSupport = true;
      efiInstallAsRemovable = true;
      device = "nodev";
    };
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/6987effb-3995-4ee5-a4bc-0c284b0ce610";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/4D2C-F188";
      fsType = "vfat";
    };
  };

  swapDevices = [{
    device = "/swapfile";
    size = 2048;
  }];
}
