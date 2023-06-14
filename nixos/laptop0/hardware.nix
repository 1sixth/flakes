{ pkgs, ... }:

let
  mountOptions = [ "compress-force=zstd" "noatime" "space_cache=v2" ];
in

{
  boot = {
    initrd.availableKernelModules = [ "nvme" "sd_mod" "usb_storage" "usbhid" ];
    kernelModules = [ "kvm-amd" ];
    loader = {
      efi.canTouchEfiVariables = true;
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
      fsType = "tmpfs";
      options = [ "mode=755" "size=100%" ];
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/4A9C-575B";
      fsType = "vfat";
    };
    "/nix" = {
      device = "/dev/disk/by-uuid/51fd9da2-48ef-4e01-8e0e-1cda6dd36281";
      fsType = "btrfs";
      options = mountOptions ++ [ "subvol=/@nix" ];
    };
    "/persistent" = {
      device = "/dev/disk/by-uuid/51fd9da2-48ef-4e01-8e0e-1cda6dd36281";
      fsType = "btrfs";
      neededForBoot = true;
      options = mountOptions ++ [ "subvol=/@persistent" ];
    };
  };

  hardware = {
    cpu.amd.updateMicrocode = true;
    firmware = with pkgs; [ linux-firmware ];
  };

  swapDevices = [{
    device = "/persistent/swapfile";
    size = 16384;
  }];
}
