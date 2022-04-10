{ config, pkgs, ... }:

let
  mountOptions = [ "compress-force=zstd" "noatime" "space_cache=v2" ];
in

{
  boot = {
    initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "uas" "sd_mod" ];
    kernelModules = [ "kvm-amd" ];
    loader = {
      efi.canTouchEfiVariables = true;
      grub.enable = false;
      systemd-boot = {
        editor = false;
        enable = true;
      };
    };
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/a844606d-0b4b-43c0-b55f-f358eb432640";
      fsType = "btrfs";
      options = mountOptions ++ [ "subvol=/@root" ];
    };
    "/nix" = {
      device = "/dev/disk/by-uuid/a844606d-0b4b-43c0-b55f-f358eb432640";
      fsType = "btrfs";
      options = mountOptions ++ [ "subvol=/@nix" ];
    };
    "/home" = {
      device = "/dev/disk/by-uuid/a844606d-0b4b-43c0-b55f-f358eb432640";
      fsType = "btrfs";
      options = mountOptions ++ [ "subvol=/@home" ];
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/1F50-F326";
      fsType = "vfat";
    };
  };

  hardware = {
    cpu.amd.updateMicrocode = true;
    firmware = with pkgs; [ linux-firmware ];
  };
}
