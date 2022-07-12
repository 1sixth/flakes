{ pkgs, ... }:

let
  device = "/dev/disk/by-id/wwn-0x5000cca267f179d8-part3";
  options = [ "noatime" "space_cache=v2" ];
in

{
  boot = {
    initrd.availableKernelModules = [ "ahci" "sd_mod" "usbhid" ];
    kernelModules = [ "kvm-intel" ];
    loader.grub.devices = [
      "/dev/disk/by-id/wwn-0x5000cca267f179d8"
      "/dev/disk/by-id/wwn-0x5000cca267f17a16"
      "/dev/disk/by-id/wwn-0x5000cca267f18dc1"
      "/dev/disk/by-id/wwn-0x5000cca273ee2b8b"
    ];
  };

  fileSystems = {
    "/" = {
      fsType = "tmpfs";
      options = [ "mode=755" ];
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
    { device = "/dev/disk/by-id/wwn-0x5000cca267f179d8-part2"; randomEncryption = true; }
    { device = "/dev/disk/by-id/wwn-0x5000cca267f17a16-part2"; randomEncryption = true; }
    { device = "/dev/disk/by-id/wwn-0x5000cca267f18dc1-part2"; randomEncryption = true; }
    { device = "/dev/disk/by-id/wwn-0x5000cca273ee2b8b-part2"; randomEncryption = true; }
  ];
}
