{ modulesPath, ... }:

{
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];

  boot = {
    initrd.availableKernelModules = [ "xhci_pci" "usbhid" ];
    loader = {
      grub.enable = false;
      systemd-boot = {
        editor = false;
        enable = true;
      };
    };
  };

  fileSystems = {
    "/" = {
      fsType = "tmpfs";
      options = [ "mode=755" ];
    };
    "/boot" = {
      device = "/dev/sda1";
      fsType = "vfat";
    };
    "/nix" = {
      device = "/dev/sda3";
      fsType = "btrfs";
      options = [ "compress-force=zstd" "noatime" "space_cache=v2" "subvol=/@nix" ];
    };
    "/persistent" = {
      device = "/dev/sda3";
      fsType = "btrfs";
      neededForBoot = true;
      options = [ "compress-force=zstd" "noatime" "space_cache=v2" "subvol=/@persistent" ];
    };
  };

  swapDevices = [{ device = "/dev/sda2"; }];
}
