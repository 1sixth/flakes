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
      device = "/dev/disk/by-uuid/d2e52659-4f5c-483e-a7c6-f896e2fca3cc";
      fsType = "btrfs";
      options = [ "compress-force=zstd" "noatime" "space_cache=v2" ];
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/2B35-2395";
      fsType = "vfat";
    };
  };

  swapDevices = [{ device = "/dev/disk/by-uuid/a2ecf42c-fa70-49aa-ace7-b2381acaa80b"; }];
}
