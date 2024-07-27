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
    kernelModules = [ "kvm-intel" ];
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
      device = "/dev/disk/by-uuid/24AD-97F5";
      fsType = "vfat";
    };
    "/nix" = {
      device = "/dev/disk/by-uuid/8b522308-2725-4d7d-878c-bc0d6f1f8c98";
      fsType = "btrfs";
      options = mountOptions ++ [ "subvol=/@nix" ];
    };
    "/persistent" = {
      device = "/dev/disk/by-uuid/8b522308-2725-4d7d-878c-bc0d6f1f8c98";
      fsType = "btrfs";
      neededForBoot = true;
      options = mountOptions ++ [ "subvol=/@persistent" ];
    };
  };

  hardware = {
    cpu.intel.updateMicrocode = true;
    firmware = with pkgs; [ linux-firmware ];
  };

  swapDevices = [
    {
      device = "/persistent/swapfile";
      size = 16384;
    }
  ];
}
