{
  config,
  pkgs,
  ...
}:

{
  boot = {
    initrd.systemd.enable = true;
    kernel.sysctl = {
      # https://github.com/torvalds/linux/blob/218af599fa635b107cfe10acf3249c4dfe5e4123/net/ipv4/tcp_bbr.c#L55
      "net.core.default_qdisc" = "fq";
      "net.ipv4.tcp_congestion_control" = "bbr";
      # https://github.com/quic-go/quic-go/wiki/UDP-Buffer-Sizes#non-bsd
      "net.core.rmem_max" = 7500000;
      "net.core.wmem_max" = 7500000;
      # https://wiki.archlinux.org/title/Zram#Optimizing_swap_on_zram
      "vm.swappiness" = 180;
      "vm.watermark_boost_factor" = 0;
      "vm.watermark_scale_factor" = 125;
      "vm.page-cluster" = 0;
    };
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      grub.configurationLimit = 5;
      systemd-boot.configurationLimit = 5;
    };
    tmp.cleanOnBoot = true;
  };

  documentation.info.enable = false;

  environment = {
    defaultPackages = [ ];
    persistence."/persistent/impermanence" = {
      directories = [
        "/root"
        "/tmp"
        "/var/lib"
        "/var/log/journal"
      ];
      files = [ "/etc/machine-id" ];
    };
    systemPackages =
      (with pkgs; [
        aria2
        curlHTTP3
        dig
        eza
        fd
        file
        iperf3
        libarchive
        nali
        nmap
        python3
        rclone
        ripgrep
        rsync
        tcpdump
      ])
      ++ (with pkgs.fishPlugins; [
        autopair
        puffer
        sponge
      ]);
  };

  networking = {
    firewall.enable = false;
    useDHCP = false;
    useNetworkd = true;
  };

  nix = {
    settings = {
      auto-allocate-uids = true;
      auto-optimise-store = true;
      experimental-features = [
        "auto-allocate-uids"
        "cgroups"
        "flakes"
        "nix-command"
      ];
      substituters = [ "https://cache.garnix.io" ];
      trusted-public-keys = [ "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g=" ];
      use-cgroups = true;
      use-xdg-base-directories = true;
    };
  };

  programs = {
    bandwhich.enable = true;
    command-not-found.enable = false;
    fish = {
      enable = true;
      interactiveShellInit = "set -g fish_greeting";
      shellAliases = {
        l = "ll --all";
        ll = "ls --group --long --time-style=long-iso";
        ls = "eza --group-directories-first --no-quotes";
        tree = "ls --tree";

        bandwhich = "bandwhich --no-resolve";

        iftop = "iftop -n -N -P";
      };
      useBabelfish = true;
    };
    htop.enable = true;
    iftop.enable = true;
    iotop.enable = true;
    less = {
      enable = true;
      # ignore case if search pattern doesn't contain uppercase letters
      envVariables.LESS = "-i";
      lessopen = null;
    };
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

  services = {
    fstrim.enable = true;
    iperf3 = {
      enable = true;
      extraFlags = [
        "--bind-dev"
        config.services.tailscale.interfaceName
      ];
    };
    journald.extraConfig = "SystemMaxUse=1G";
    tailscale = {
      authKeyFile = config.sops.secrets.tailscale_key.path;
      enable = true;
      extraDaemonFlags = [ "--no-logs-no-support" ];
      extraUpFlags = [
        "--accept-dns=false"
        "--ssh"
      ];
    };
    userborn.enable = true;
  };

  sops = {
    age = {
      keyFile = "/var/lib/sops.key";
      sshKeyPaths = [ ];
    };
    secrets.tailscale_key.sopsFile = ./secrets.yaml;
  };

  system = {
    etc.overlay.enable = true;
    stateVersion = "24.11";
  };

  systemd.network.networks.default.DHCP = "yes";

  time.timeZone = "Asia/Shanghai";

  users = {
    mutableUsers = false;
    users.root.shell = pkgs.fish;
  };

  zramSwap.enable = true;
}
