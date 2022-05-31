{ pkgs, ... }:

let
  mountOptions = [ "noatime" "space_cache=v2" ];
in

{
  boot = {
    initrd.availableKernelModules = [ "ahci" "sd_mod" "xhci_pci" ];
    kernelModules = [ "kvm-intel" ];
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
      options = [ "mode=755" ];
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/0B4B-1882";
      fsType = "vfat";
    };
    "/nix" = {
      device = "/dev/disk/by-uuid/fa12c800-105d-4fa1-87f9-a1f8b54ad8c1";
      fsType = "btrfs";
      options = mountOptions ++ [ "compress-force=zstd" "subvol=/@nix" ];
    };
    "/persistent" = {
      device = "/dev/disk/by-uuid/fa12c800-105d-4fa1-87f9-a1f8b54ad8c1";
      fsType = "btrfs";
      neededForBoot = true;
      options = mountOptions ++ [ "compress-force=zstd" "subvol=/@persistent" ];
    };
    "/persistent/8T" = {
      device = "/dev/disk/by-uuid/51365bbd-db45-44ca-b234-3b13d345cb3b";
      fsType = "btrfs";
      options = mountOptions ++ [ "autodefrag" ];
    };
    "/persistent/16T" = {
      device = "/dev/disk/by-uuid/db363a22-3029-414e-9bb0-b21f25ed4c1b";
      fsType = "btrfs";
      options = mountOptions ++ [ "autodefrag" ];
    };
  };

  hardware.cpu.intel.updateMicrocode = true;

  swapDevices = [{ device = "/dev/disk/by-uuid/31ed7cfb-2c2e-42e7-80cf-45397d708d19"; }];
}
