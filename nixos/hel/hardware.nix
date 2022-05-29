{ pkgs, ... }:

let
  device = "/dev/disk/by-id/wwn-0x5000c500b386b349-part3";
  options = [ "compress-force=zstd" "noatime" "space_cache=v2" ];
in

{
  boot = {
    initrd.availableKernelModules = [ "ahci" "sd_mod" "usbhid" ];
    kernelModules = [ "kvm-intel" ];
    loader.grub.devices = [
      "/dev/disk/by-id/wwn-0x5000c500b386b349"
      "/dev/disk/by-id/wwn-0x5000c500c3b0ee78"
      "/dev/disk/by-id/wwn-0x5000c500c3b49c8c"
      "/dev/disk/by-id/wwn-0x5000c500c3ba73f0"
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
    { device = "/dev/disk/by-id/wwn-0x5000c500b386b349-part2"; randomEncryption = true; }
    { device = "/dev/disk/by-id/wwn-0x5000c500c3b0ee78-part2"; randomEncryption = true; }
    { device = "/dev/disk/by-id/wwn-0x5000c500c3b49c8c-part2"; randomEncryption = true; }
    { device = "/dev/disk/by-id/wwn-0x5000c500c3ba73f0-part2"; randomEncryption = true; }
  ];
}
