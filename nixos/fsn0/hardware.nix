{ modulesPath, ... }:

let
  mountOptions = [ "compress-force=zstd" "noatime" "space_cache=v2" ];
in

{
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];

  boot = {
    initrd.availableKernelModules = [ "xhci_pci" "usbhid" "sr_mod" ];
    loader = {
      grub.enable = false;
      systemd-boot = {
        editor = false;
        enable = true;
      };
    };
  };

  fileSystems = {
    "/" = {
      fsType = "tmpfs";
      options = [ "mode=755" "size=100%" ];
    };
    "/boot" = {
      device = "/dev/sda1";
      fsType = "vfat";
    };
    "/nix" = {
      device = "/dev/sda2";
      fsType = "btrfs";
      options = mountOptions ++ [ "subvol=/@nix" ];
    };
    "/persistent" = {
      device = "/dev/sda2";
      fsType = "btrfs";
      neededForBoot = true;
      options = mountOptions ++ [ "subvol=/@persistent" ];
    };
  };

  swapDevices = [{
    device = "/persistent/swapfile";
    size = 4096;
  }];
}
