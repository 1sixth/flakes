{ ... }:

let
  mountOptions = [
    "noatime"
    "space_cache=v2"
  ];
in

{
  boot = {
    initrd.availableKernelModules = [
      "ahci"
      "sd_mod"
      "xhci_pci"
    ];
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
      options = [
        "mode=755"
        "size=100%"
      ];
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/010B-AFC3";
      fsType = "vfat";
    };
    "/nix" = {
      device = "/dev/disk/by-uuid/ae973210-fc9b-4ea2-88fe-d09f8485dab8";
      fsType = "btrfs";
      options = mountOptions ++ [
        "compress-force=zstd"
        "subvol=/@nix"
      ];
    };
    "/persistent" = {
      device = "/dev/disk/by-uuid/ae973210-fc9b-4ea2-88fe-d09f8485dab8";
      fsType = "btrfs";
      neededForBoot = true;
      options = mountOptions ++ [
        "compress-force=zstd"
        "subvol=/@persistent"
      ];
    };
    "/persistent/8T" = {
      device = "/dev/disk/by-uuid/51365bbd-db45-44ca-b234-3b13d345cb3b";
      fsType = "btrfs";
      options = mountOptions;
    };
    "/persistent/16T" = {
      device = "/dev/disk/by-uuid/db363a22-3029-414e-9bb0-b21f25ed4c1b";
      fsType = "btrfs";
      options = mountOptions;
    };
  };

  hardware.cpu.intel.updateMicrocode = true;

  swapDevices = [ { device = "/dev/disk/by-uuid/a2ab50d8-70bb-42a4-90d6-f288addd4540"; } ];
}
