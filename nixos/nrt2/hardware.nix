{ modulesPath, ... }:

let
  mountOptions = [ "compress-force=zstd" "discard=async" "noatime" "space_cache=v2" ];
in

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
      options = mountOptions ++ [ "subvol=/@nix" ];
    };
    "/persistent" = {
      device = "/dev/sda3";
      fsType = "btrfs";
      neededForBoot = true;
      options = mountOptions ++ [ "subvol=/@persistent" ];
    };
  };

  swapDevices = [{ device = "/dev/sda2"; }];
}
