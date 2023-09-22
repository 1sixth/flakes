{ pkgs, ... }:

let
  mountOptions = [ "compress-force=zstd" "noatime" "space_cache=v2" ];
in

{
  boot = {
    initrd.availableKernelModules = [ "nvme" "sd_mod" "usb_storage" "xhci_pci" ];
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
      options = [ "mode=755" "size=200%" ];
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/4E1B-2A50";
      fsType = "vfat";
    };
    "/nix" = {
      device = "/dev/disk/by-uuid/0080291b-9ff4-470f-9c78-569ee68eb49d";
      fsType = "btrfs";
      options = mountOptions ++ [ "subvol=/@nix" ];
    };
    "/persistent" = {
      device = "/dev/disk/by-uuid/0080291b-9ff4-470f-9c78-569ee68eb49d";
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
