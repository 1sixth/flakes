{ pkgs, ... }:

let
  # HDD, 2 * 6T, RAID 0.
  HDD = "/dev/disk/by-id/wwn-0x5000cca24dc48f99";
  # NVMe SSD, 1 * 512G.
  SSD = "/dev/disk/by-id/nvme-eui.002538ba11b646a1";
  mountOptions = [ "noatime" "space_cache=v2" ];
in

{
  boot = {
    initrd.availableKernelModules = [ "ahci" "nvme" "sd_mod" "xhci_pci" ];
    kernelModules = [ "kvm-amd" ];
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
      device = SSD + "-part2";
      fsType = "btrfs";
      options = mountOptions ++ [ "compress-force=zstd" "subvol=/@root" ];
    };
    "/boot" = {
      device = SSD + "-part1";
      fsType = "vfat";
    };
    "/nix" = {
      device = SSD + "-part2";
      fsType = "btrfs";
      options = mountOptions ++ [ "compress-force=zstd" "subvol=/@nix" ];
    };
    "/persistent" = {
      device = HDD;
      fsType = "btrfs";
      options = mountOptions ++ [ "subvol=/@persistent" ];
    };
  };

  hardware.cpu.amd.updateMicrocode = true;
}
