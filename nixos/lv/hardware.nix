{ modulesPath, ... }:

let
  options = [ "compress-force=zstd" "noatime" "space_cache=v2" ];
in

{
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];

  boot = {
    kernelModules = [ "kvm-amd" ];
    initrd.availableKernelModules = [ "ata_piix" "uhci_hcd" "sr_mod" ];
    loader.grub.device = "/dev/vda";
  };

  fileSystems = {
    "/" = {
      fsType = "tmpfs";
      options = [ "mode=755" ];
    };
    "/boot" = {
      device = "/dev/vda3";
      fsType = "btrfs";
      options = options ++ [ "subvol=/@boot" ];
    };
    "/nix" = {
      device = "/dev/vda3";
      fsType = "btrfs";
      options = options ++ [ "subvol=/@nix" ];
    };
    "/persistent" = {
      device = "/dev/vda3";
      fsType = "btrfs";
      neededForBoot = true;
      options = options ++ [ "subvol=/@persistent" ];
    };
  };

  swapDevices = [{ device = "/dev/vda2"; }];
}
