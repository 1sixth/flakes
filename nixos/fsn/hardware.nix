{ pkgs, ... }:

let
  device = "/dev/disk/by-id/wwn-0x500003979c38042c-part2";
  mountOptions = [ "compress-force=zstd" "noatime" "space_cache=v2" ];
in

{
  boot = {
    initrd.availableKernelModules = [ "ahci" "sd_mod" ];
    kernelModules = [ "kvm-intel" ];
    loader.grub.devices = [
      "/dev/disk/by-id/wwn-0x500003979c38042c"
      "/dev/disk/by-id/wwn-0x500003982c8027c3"
      "/dev/disk/by-id/wwn-0x5000cca24dd2fd85"
      "/dev/disk/by-id/wwn-0x5000cca255cd33e5"
    ];
  };

  fileSystems = {
    "/" = {
      inherit device;
      fsType = "btrfs";
      options = mountOptions ++ [ "subvol=/@root" ];
    };
    "/nix" = {
      inherit device;
      fsType = "btrfs";
      options = mountOptions ++ [ "subvol=/@nix" ];
    };
    "/persistent" = {
      inherit device;
      fsType = "btrfs";
      options = mountOptions ++ [ "subvol=/@persistent" ];
    };
  };

  hardware.cpu.intel.updateMicrocode = true;
}
