{ modulesPath, ... }:

{
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];

  boot = {
    kernelModules = [ "kvm-amd" ];
    initrd.availableKernelModules = [ "ata_piix" "uhci_hcd" "sd_mod" ];
    loader.grub = {
      device = "nodev";
      efiInstallAsRemovable = true;
      efiSupport = true;
    };
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/5e5fd1b5-92ad-495a-8c43-95994ac940c4";
      fsType = "btrfs";
      options = [ "compress-force=zstd" "noatime" "space_cache=v2" ];
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/072B-3443";
      fsType = "vfat";
    };
  };

  swapDevices = [{ device = "/dev/disk/by-uuid/6d409d62-ad1e-4e0f-9d23-2a3238c63027"; }];
}
