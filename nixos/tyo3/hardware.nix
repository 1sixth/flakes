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
      device = "/dev/disk/by-uuid/90e217c9-e854-478f-939a-a0cc2bce52f4";
      fsType = "btrfs";
      options = [ "compress-force=zstd" "noatime" "space_cache=v2" ];
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/9DB2-D0B8";
      fsType = "vfat";
    };
  };

  swapDevices = [{ device = "/dev/disk/by-uuid/0cd4051e-3437-47c3-876a-4cd1b58ba7ce"; }];
}
