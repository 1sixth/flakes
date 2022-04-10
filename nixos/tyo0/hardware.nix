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
      device = "/dev/disk/by-uuid/38fc8aab-bb15-47ec-97a4-a8209a676d7b";
      fsType = "xfs";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/BB6A-4956";
      fsType = "vfat";
    };
  };
  swapDevices = [{ device = "/dev/disk/by-uuid/041e6e37-8fdb-48c0-92c9-b238ffa90d4c"; }];
}
