{ modulesPath, ... }:

{
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];

  boot = {
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
      device = "/dev/disk/by-uuid/d7651567-b698-4852-84a3-7693a84b7a52";
      fsType = "btrfs";
      options = [ "compress-force=zstd" "noatime" "space_cache=v2" ];
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/0B73-4017";
      fsType = "vfat";
    };
  };

  swapDevices = [{ device = "/dev/disk/by-uuid/c3c55794-8055-4a0f-b9a9-968afef4e29b"; }];
}
