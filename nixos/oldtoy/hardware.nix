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
      device = "/dev/disk/by-uuid/AD03-D091";
      fsType = "vfat";
    };
    "/nix" = {
      device = "/dev/disk/by-uuid/b6462b79-c6f3-4732-a065-66887de23043";
      fsType = "btrfs";
      options = mountOptions ++ [ "subvol=/@nix" ];
    };
    "/persistent" = {
      device = "/dev/disk/by-uuid/b6462b79-c6f3-4732-a065-66887de23043";
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
