{ inputs, pkgs, ... }:

{
  boot = {
    initrd.systemd.enable = true;
    kernel.sysctl = {
      # https://github.com/torvalds/linux/blob/218af599fa635b107cfe10acf3249c4dfe5e4123/net/ipv4/tcp_bbr.c#L55
      "net.core.default_qdisc" = "fq";
      "net.ipv4.tcp_congestion_control" = "bbr";
      # https://github.com/quic-go/quic-go/wiki/UDP-Buffer-Sizes#non-bsd
      "net.core.rmem_max" = 2500000;
      "net.core.wmem_max" = 2500000;
      # https://wiki.archlinux.org/title/Zram#Optimizing_swap_on_zram
      "vm.swappiness" = 180;
      "vm.watermark_boost_factor" = 0;
      "vm.watermark_scale_factor" = 125;
      "vm.page-cluster" = 0;
    };
    swraid.enable = false;
    tmp.cleanOnBoot = true;
  };

  documentation.info.enable = false;

  environment = {
    persistence."/persistent/impermanence" = {
      directories = [
        "/root"
        "/tmp"
        "/var/lib"
        "/var/log/journal"
      ];
      files = [ "/etc/machine-id" ];
    };
    systemPackages = with pkgs; [
      fd
      file
      ldns
      rclone
      ripgrep
      tcpdump
    ];
  };

  networking = {
    firewall.enable = false;
    useDHCP = false;
    useNetworkd = true;
  };

  nix = {
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 7d";
    };
    registry.nixpkgs.flake = inputs.nixpkgs;
    settings = {
      auto-allocate-uids = true;
      auto-optimise-store = true;
      experimental-features = [
        "auto-allocate-uids"
        "cgroups"
        "flakes"
        "nix-command"
      ];
      flake-registry = "/etc/nix/registry.json";
      nix-path = [ "nixpkgs=${inputs.nixpkgs}" ];
      substituters = [ "https://cache.garnix.io" ];
      trusted-public-keys = [ "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g=" ];
      use-cgroups = true;
      use-xdg-base-directories = true;
    };
  };

  programs = {
    command-not-found.enable = false;
    fish = {
      enable = true;
      useBabelfish = true;
    };
    htop.enable = true;
    iftop.enable = true;
    iotop.enable = true;
    mtr.enable = true;
    nano.enable = false;
    ssh.knownHosts = {
      "github.com".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl";
      "gitlab.com".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAfuCHKVTjquxvt6CM6tdG4SLp1Btn/nOeHHE5UOzRdf";
    };
    starship = {
      enable = true;
      settings.add_newline = false;
    };
    traceroute.enable = true;
  };

  security.pki.caCertificateBlacklist = [
    "BJCA Global Root CA1"
    "BJCA Global Root CA2"
    "CFCA EV ROOT"
    "GDCA TrustAUTH R5 ROOT"
    "UCA Extended Validation Root"
    "UCA Global G2 Root"
    "vTrus ECC Root CA"
    "vTrus Root CA"
  ];

  services.journald.extraConfig = "SystemMaxUse=1G";

  sops.age = {
    keyFile = "/var/lib/sops.key";
    sshKeyPaths = [ ];
  };

  system.stateVersion = "22.05";

  systemd.network.networks.default.DHCP = "yes";

  time.timeZone = "Asia/Shanghai";

  users = {
    mutableUsers = false;
    users.root.shell = pkgs.fish;
  };

  zramSwap.enable = true;
}
