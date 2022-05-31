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
      fsType = "tmpfs";
      options = [ "mode=755" ];
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/6EA8-2AF8";
      fsType = "vfat";
    };
    "/nix" = {
      device = "/dev/disk/by-uuid/c0a93644-d86c-4809-a1a5-008c27c63226";
      fsType = "btrfs";
      options = mountOptions ++ [ "subvol=/@nix" ];
    };
    "/persistent" = {
      device = "/dev/disk/by-uuid/c0a93644-d86c-4809-a1a5-008c27c63226";
      fsType = "btrfs";
      neededForBoot = true;
      options = mountOptions ++ [ "subvol=/@persistent" ];
    };
  };

  hardware = {
    cpu.amd.updateMicrocode = true;
    firmware = with pkgs; [ linux-firmware ];
  };

  swapDevices = [{ device = "/dev/disk/by-uuid/c0c751c1-3564-4c97-8242-6e97105aa124"; }];
}
