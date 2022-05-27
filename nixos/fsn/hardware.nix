{ pkgs, ... }:

let
  device = "/dev/disk/by-id/wwn-0x5000039978ca202a-part3";
  options = [ "compress-force=zstd" "noatime" "space_cache=v2" ];
in

{
  boot = {
    initrd.availableKernelModules = [ "ahci" "sd_mod" "usbhid" ];
    kernelModules = [ "kvm-intel" ];
    loader.grub.devices = [
      "/dev/disk/by-id/wwn-0x5000039978ca202a"
      "/dev/disk/by-id/wwn-0x5000039978ca2031"
      "/dev/disk/by-id/wwn-0x5000039978ca2032"
      "/dev/disk/by-id/wwn-0x5000039978ca2039"
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
    { device = "/dev/disk/by-id/wwn-0x5000039978ca202a-part2"; randomEncryption = true; }
    { device = "/dev/disk/by-id/wwn-0x5000039978ca2031-part2"; randomEncryption = true; }
    { device = "/dev/disk/by-id/wwn-0x5000039978ca2032-part2"; randomEncryption = true; }
    { device = "/dev/disk/by-id/wwn-0x5000039978ca2039-part2"; randomEncryption = true; }
  ];
}
