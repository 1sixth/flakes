{ pkgs, ... }:

let
  mountOptions = [ "noatime" "space_cache=v2" ];
in

{
  boot = {
    initrd.availableKernelModules = [ "ahci" "sd_mod" "xhci_pci" ];
    kernelModules = [ "kvm-intel" ];
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
      device = "/dev/disk/by-uuid/97785409-fe30-4f4d-a014-5b6937d93190";
      fsType = "btrfs";
      options = mountOptions ++ [ "compress-force=zstd" ];
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/BB59-C92B";
      fsType = "vfat";
    };
    "/persistent/8T" = {
      device = "/dev/disk/by-uuid/51365bbd-db45-44ca-b234-3b13d345cb3b";
      options = mountOptions;
    };
    "/persistent/16T" = {
      device = "/dev/disk/by-uuid/db363a22-3029-414e-9bb0-b21f25ed4c1b";
      options = mountOptions;
    };
  };

  hardware.cpu.intel.updateMicrocode = true;
}
