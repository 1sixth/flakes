{ inputs, lib, pkgs, ... }:

{
  boot = {
    cleanTmpDir = true;
    kernel.sysctl = {
      # https://github.com/torvalds/linux/blob/8032bf1233a74627ce69b803608e650f3f35971c/net/ipv4/tcp_bbr.c
      "net.core.default_qdisc" = "fq";
      "net.ipv4.tcp_congestion_control" = "bbr";
      # https://github.com/lucas-clemente/quic-go/wiki/UDP-Receive-Buffer-Size#non-bsd
      "net.core.rmem_max" = 2500000;
    };
    kernelPackages = pkgs.linuxPackages_latest;
  };

  environment = {
    defaultPackages = lib.mkForce [ ];
    persistence."/persistent/impermanence" = {
      directories = [
        "/var/lib"
        "/var/log/journal"
      ];
      files = [
        "/etc/machine-id"
      ];
    };
  };

  networking = {
    firewall.enable = false;
    useDHCP = false;
    useNetworkd = true;
  };

  nix = {
    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
      persistent = true;
    };
    nrBuildUsers = 0;
    registry.nixpkgs.flake = inputs.nixpkgs;
    settings = {
      auto-allocate-uids = true;
      auto-optimise-store = true;
      experimental-features = [ "auto-allocate-uids" "cgroups" "flakes" "nix-command" ];
      flake-registry = "/etc/nix/registry.json";
      nix-path = [ "nixpkgs=${inputs.nixpkgs}" ];
      use-cgroups = true;
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
    nano.syntaxHighlight = false;
    starship = {
      enable = true;
      settings.add_newline = false;
    };
    traceroute.enable = true;
  };

  security.pki.caCertificateBlacklist = [
    "CFCA EV ROOT"
    "TrustCor ECA-1"
    "TrustCor RootCert CA-1"
    "TrustCor RootCert CA-2"
    "vTrus ECC Root CA"
    "vTrus Root CA"
  ];

  services.journald.extraConfig = "SystemMaxUse=1G";

  sops = {
    age = {
      keyFile = "/var/lib/sops.key";
      sshKeyPaths = [ ];
    };
    gnupg.sshKeyPaths = [ ];
  };
  system.stateVersion = "22.05";

  systemd.network = {
    enable = true;
    networks.default.DHCP = "yes";
  };

  time.timeZone = "Asia/Shanghai";

  users = {
    mutableUsers = false;
    users.root.shell = pkgs.fish;
  };
}
