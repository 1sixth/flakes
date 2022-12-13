{ pkgs, ... }:

let
  mountOptions = [ "compress-force=zstd" "discard=async" "noatime" "space_cache=v2" ];
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
      device = "/dev/disk/by-uuid/C016-FDA5";
      fsType = "vfat";
    };
    "/nix" = {
      device = "/dev/disk/by-uuid/2cc6c9d1-d10e-497b-b5b5-31761ab9bff2";
      fsType = "btrfs";
      options = mountOptions ++ [ "subvol=/@nix" ];
    };
    "/persistent" = {
      device = "/dev/disk/by-uuid/2cc6c9d1-d10e-497b-b5b5-31761ab9bff2";
      fsType = "btrfs";
      neededForBoot = true;
      options = mountOptions ++ [ "subvol=/@persistent" ];
    };
  };

  hardware = {
    cpu.amd.updateMicrocode = true;
    firmware = with pkgs; [ linux-firmware ];
  };

  swapDevices = [{ device = "/dev/disk/by-uuid/4b7d1da3-3842-4d19-8b11-6067042ee1b4"; }];
}
