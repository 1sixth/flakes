{ pkgs, ... }:

let
  mountOptions = [ "compress-force=zstd" "noatime" "space_cache=v2" ];
in

{
  boot = {
    initrd.availableKernelModules = [ "ahci" "nvme" "usbhid" "xhci_pci" ];
    kernelModules = [ "kvm-amd" ];
    loader = {
      grub.enable = false;
      systemd-boot = {
        editor = false;
        enable = true;
      };
      timeout = 0;
    };
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/251085ac-59ea-4e30-9d33-71dfdf781966";
      fsType = "btrfs";
      options = mountOptions ++ [ "subvol=/@root" ];
    };
    "/nix" = {
      device = "/dev/disk/by-uuid/251085ac-59ea-4e30-9d33-71dfdf781966";
      fsType = "btrfs";
      options = mountOptions ++ [ "subvol=/@nix" ];
    };
    "/home" = {
      device = "/dev/disk/by-uuid/251085ac-59ea-4e30-9d33-71dfdf781966";
      fsType = "btrfs";
      options = mountOptions ++ [ "subvol=/@home" ];
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/641C-6BB3";
      fsType = "vfat";
    };
  };

  hardware = {
    cpu.amd.updateMicrocode = true;
    firmware = with pkgs; [ linux-firmware ];
  };

  swapDevices = [{ device = "/dev/disk/by-uuid/c2caae82-c764-4d01-aefc-096c5b3f38b5"; }];
}
