{ modulesPath, ... }:

let
  mountOptions = [ "compress-force=zstd" "noatime" "space_cache=v2" ];
in

{
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];

  boot = {
    kernelModules = [ "kvm-amd" ];
    initrd.availableKernelModules = [ "ata_piix" "uhci_hcd" "sd_mod" ];
    loader.grub.device = "/dev/vda";
  };

  fileSystems = {
    "/" = {
      fsType = "tmpfs";
      options = [ "mode=755" ];
    };
    "/boot" = {
      device = "/dev/vda2";
      fsType = "btrfs";
      options = mountOptions ++ [ "subvol=/@boot" ];
    };
    "/nix" = {
      device = "/dev/vda2";
      fsType = "btrfs";
      options = mountOptions ++ [ "subvol=/@nix" ];
    };
    "/persistent" = {
      device = "/dev/vda2";
      fsType = "btrfs";
      neededForBoot = true;
      options = mountOptions ++ [ "subvol=/@persistent" ];
    };
  };

  swapDevices = [{
    device = "/persistent/swapfile";
    size = 1024;
  }];
}
