{ config, lib, pkgs, ... }:

{
  imports = [ ./hardware.nix ];

  boot = {
    cleanTmpDir = true;
    binfmt.emulatedSystems = [ "aarch64-linux" "riscv64-linux" ];
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
  };

  environment = {
    defaultPackages = lib.mkForce [ ];
    etc."nixos/flake.nix".source = "${config.users.users.one6th.home}/Develop/flakes/flake.nix";
    persistence."/persistent/impermanence" = {
      directories = [
        "/tmp"
        "/var/lib"
        "/var/log/journal"
        { directory = "/mnt"; user = "one6th"; group = "users"; }
      ];
      files = [
        "/etc/machine-id"
      ];
      users.one6th.directories = [
        ".cache/nix"
        ".cache/nix-index"
        ".config/chromium"
        ".config/fcitx5"
        ".config/htop"
        ".config/JetBrains"
        ".config/Mumble"
        ".config/pcmanfm-qt"
        ".config/rclone"
        ".config/VSCodium"
        ".config/wireshark"
        ".local/share/fcitx5"
        ".local/share/fish"
        ".local/share/JetBrains"
        ".local/share/Mumble"
        ".local/share/nvim"
        ".local/share/PolyMC"
        ".local/share/TelegramDesktop"
        ".local/state/gnupg"
        ".local/state/wireplumber"
        ".ssh"
        ".thunderbird"
        ".vscode-oss"
        "Develop"
        "Download"
      ];
    };
  };

  fonts = {
    enableDefaultFonts = false;
    fonts = with pkgs; [
      font-awesome
      (iosevka-bin.override {
        variant = "sgr-iosevka-fixed";
      })
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-emoji
      noto-fonts-extra
    ];
  };

  hardware.bluetooth = {
    enable = true;
    settings.Policy.ReconnectAttempts = 0;
  };

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
      fcitx5-pinyin-zhwiki-nickcao
    ];
  };

  nix.settings = {
    auto-optimise-store = true;
    builders-use-substitutes = true;
    experimental-features = [ "flakes" "nix-command" ];
    substituters = [ "https://hydra.shinta.ro" ];
    trusted-public-keys = [ "hydra.shinta.ro:nxVZvKRpeiGdqeiHJ7QRm4GYOF/7BuFpOnaPULw+QX4=" ];
    trusted-users = [ "one6th" "root" ];
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
    traceroute.enable = true;
    wireshark = {
      enable = true;
      package = pkgs.wireshark-qt;
    };
  };

  qt5.platformTheme = "qt5ct";

  security = {
    pam.u2f = {
      authFile = config.sops.secrets.u2f_keys.path;
      cue = true;
      enable = true;
    };
    rtkit.enable = true;
    sudo.extraConfig = ''Defaults lecture="never"'';
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
      password_root.neededForUsers = true;
      password_one6th.neededForUsers = true;
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
        passwordFile = config.sops.secrets.password_one6th.path;
        shell = pkgs.fish;
      };
      root.passwordFile = config.sops.secrets.password_root.path;
    };
  };
}
