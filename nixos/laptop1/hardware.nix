{ pkgs, ... }:

let
  mountOptions = [
    "compress-force=zstd"
    "noatime"
    "space_cache=v2"
  ];
in

{
  boot = {
    initrd.availableKernelModules = [
      "nvme"
      "sd_mod"
      "usb_storage"
      "xhci_pci"
    ];
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
      options = [
        "mode=755"
        "size=200%"
      ];
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/6860-8E52";
      fsType = "vfat";
    };
    "/nix" = {
      device = "/dev/disk/by-uuid/e6a1f69c-5d3b-4b82-922c-ec698b710e8a";
      fsType = "btrfs";
      options = mountOptions ++ [ "subvol=/@nix" ];
    };
    "/persistent" = {
      device = "/dev/disk/by-uuid/e6a1f69c-5d3b-4b82-922c-ec698b710e8a";
      fsType = "btrfs";
      neededForBoot = true;
      options = mountOptions ++ [ "subvol=/@persistent" ];
    };
  };

  hardware = {
    cpu.amd.updateMicrocode = true;
    firmware = with pkgs; [ linux-firmware ];
  };

  swapDevices = [
    {
      device = "/persistent/swapfile";
      size = 16384;
    }
  ];
}
