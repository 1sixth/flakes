{ pkgs, ... }:

let
  device = "/dev/disk/by-id/wwn-0x50000399e8d30a8f-part3";
  options = [ "compress-force=zstd" "noatime" "space_cache=v2" ];
in

{
  boot = {
    initrd.availableKernelModules = [ "ahci" "sd_mod" "usbhid" ];
    kernelModules = [ "kvm-intel" ];
    loader.grub.devices = [
      "/dev/disk/by-id/wwn-0x50000399e8d30a8f"
      "/dev/disk/by-id/wwn-0x50000399e8d314c0"
      "/dev/disk/by-id/wwn-0x50000399e8d31719"
      "/dev/disk/by-id/wwn-0x50000399e8d3363d"
    ];
  };

  fileSystems = {
    "/" = {
      fsType = "tmpfs";
      options = [ "mode=755" "size=100%" ];
    };
    "/boot" = {
      inherit device;
      fsType = "btrfs";
      options = options ++ [ "subvol=/@boot" ];
    };
    "/nix" = {
      inherit device;
      fsType = "btrfs";
      options = options ++ [ "subvol=/@nix" ];
    };
    "/persistent" = {
      inherit device;
      fsType = "btrfs";
      neededForBoot = true;
      options = options ++ [ "subvol=/@persistent" ];
    };
  };

  hardware.cpu.intel.updateMicrocode = true;

  swapDevices = [
    { device = "/dev/disk/by-id/wwn-0x50000399e8d30a8f-part2"; randomEncryption = true; }
    { device = "/dev/disk/by-id/wwn-0x50000399e8d314c0-part2"; randomEncryption = true; }
    { device = "/dev/disk/by-id/wwn-0x50000399e8d31719-part2"; randomEncryption = true; }
    { device = "/dev/disk/by-id/wwn-0x50000399e8d3363d-part2"; randomEncryption = true; }
  ];
}
