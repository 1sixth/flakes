{ config, lib, pkgs, ... }:

{
  imports = [ ./hardware.nix ];

  boot = {
    binfmt.emulatedSystems = [ "aarch64-linux" ];
    kernel.sysctl = {
      # https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/net/ipv4/tcp_bbr.c#n55
      "net.core.default_qdisc" = "fq";
      "net.ipv4.tcp_congestion_control" = "bbr";
      # https://github.com/lucas-clemente/quic-go/wiki/UDP-Receive-Buffer-Size#non-bsd
      "net.core.rmem_max" = "2500000";
    };
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [ "acpi_backlight=native" ];
    supportedFilesystems = [ "ntfs" ];
    tmpOnTmpfs = true;
  };

  fonts.fonts = with pkgs; [
    font-awesome
    iosevka-bin
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-emoji
    noto-fonts-extra
  ];

  hardware.bluetooth.enable = true;

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.one6th = import ./home;
  };

  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-chinese-addons
      fcitx5-material-color
      fcitx5-pinyin-moegirl
      fcitx5-pinyin-zhwiki
    ];
  };

  nix = {
    buildMachines = [
      {
        hostName = "hel.9875321.xyz";
        sshUser = "root";
        supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
        systems = [
          #"aarch64-linux"
          "x86_64-linux"
        ];
      }
      {
        hostName = "tyo0.9875321.xyz";
        sshUser = "root";
        supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" "gccarch-armv8-a" ];
        systems = [
          "aarch64-linux"
          #"x86_64-linux"
        ];
      }
    ];
    distributedBuilds = true;
    settings = {
      auto-optimise-store = true;
      builders-use-substitutes = true;
      experimental-features = [ "flakes" "nix-command" ];
      trusted-users = [ "one6th" "root" ];
    };
  };

  networking = {
    firewall.enable = false;
    hostName = "toy";
    useDHCP = false;
    useNetworkd = true;
    wireless.iwd.enable = true;
  };

  powerManagement.cpuFreqGovernor = "schedutil";

  programs = {
    command-not-found.enable = false;
    sway = {
      enable = true;
      wrapperFeatures.gtk = true;
    };
    fish.enable = true;
    iftop.enable = true;
    mtr.enable = true;
    qt5ct.enable = true;
    traceroute.enable = true;
    wireshark = {
      enable = true;
      package = pkgs.wireshark-qt;
    };
  };

  security = {
    pam.u2f = {
      authFile = config.sops.secrets.u2f_keys.path;
      cue = true;
      enable = true;
    };
    rtkit.enable = true;
  };

  services = {
    fstrim.enable = true;
    getty.autologinUser = "one6th";
    journald.extraConfig = "SystemMaxUse=1G";
    logind.lidSwitch = "ignore";
    pipewire = {
      alsa.enable = true;
      enable = true;
      jack.enable = true;
      pulse.enable = true;
    };
    tlp.enable = true;
  };

  system.stateVersion = "22.05";

  systemd.network = {
    enable = true;
    networks.wlan = {
      DHCP = "yes";
      matchConfig.Type = "wlan";
    };
  };

  sops = {
    age.keyFile = "/var/lib/sops.key";
    defaultSopsFile = ./secrets.yaml;
    secrets = {
      "password/root".neededForUsers = true;
      "password/one6th".neededForUsers = true;
      u2f_keys.mode = "0444";
    };
  };

  time.timeZone = "Asia/Shanghai";

  users = {
    mutableUsers = false;
    users = {
      one6th = {
        isNormalUser = true;
        extraGroups = [ "wheel" "wireshark" ];
        passwordFile = config.sops.secrets."password/one6th".path;
        shell = pkgs.fish;
      };
      root.passwordFile = config.sops.secrets."password/root".path;
    };
  };
}
