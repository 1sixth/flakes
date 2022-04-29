{ modulesPath, ... }:

{
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];

  boot = {
    kernelModules = [ "kvm-amd" ];
    initrd.availableKernelModules = [ "ata_piix" "uhci_hcd" "sd_mod" ];
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
      device = "/dev/disk/by-uuid/4dd28523-2dfb-40c6-91ae-fd1d7dcd8b2c";
      fsType = "btrfs";
      options = [ "compress-force=zstd" "noatime" "space_cache=v2" ];
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/D8C8-FF86";
      fsType = "vfat";
    };
  };

  swapDevices = [{ device = "/dev/disk/by-uuid/016d6bb9-9d11-4b27-b7f1-b39022a1e1d4"; }];
}
