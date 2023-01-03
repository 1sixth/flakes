{ config, lib, pkgs, ... }:

{
  imports = [ ./hardware.nix ];

  boot = {
    cleanTmpDir = true;
    binfmt.emulatedSystems = [ "aarch64-linux" ];
    kernel.sysctl = {
      # https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/net/ipv4/tcp_bbr.c#n55
      "net.core.default_qdisc" = "fq";
      "net.ipv4.tcp_congestion_control" = "bbr";
      # https://github.com/lucas-clemente/quic-go/wiki/UDP-Receive-Buffer-Size#non-bsd
      "net.core.rmem_max" = 2500000;
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
        ".cache/pypoetry"
        ".config/chromium"
        ".config/Crow Translate"
        ".config/fcitx5"
        ".config/htop"
        ".config/JetBrains"
        ".config/mpv/watch_later"
        ".config/nali"
        ".config/obsidian"
        ".config/rclone"
        ".config/VSCodium"
        ".config/wireshark"
        ".local/share/fcitx5"
        ".local/share/fish"
        ".local/share/JetBrains"
        ".local/share/nali"
        ".local/share/nvim"
        ".local/share/TelegramDesktop"
        ".local/share/virtualenv"
        ".local/state/gnupg"
        ".local/state/nvim"
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
      (iosevka-bin.override {
        variant = "sgr-iosevka-fixed-slab";
      })
      (nerdfonts.override {
        fonts = [ "NerdFontsSymbolsOnly" ];
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
    ];
  };

  networking = {
    firewall.enable = false;
    hostName = "toy";
    useDHCP = false;
    useNetworkd = true;
    wireless.iwd.enable = true;
  };

  nix = {
    nrBuildUsers = 0;
    settings = {
      auto-allocate-uids = true;
      auto-optimise-store = true;
      experimental-features = [ "auto-allocate-uids" "cgroups" "flakes" "nix-command" ];
      trusted-users = [ "one6th" "root" ];
      use-cgroups = true;
    };
  };

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "obsidian"
  ];

  powerManagement.cpuFreqGovernor = "schedutil";

  programs = {
    command-not-found.enable = false;
    sway = {
      enable = true;
      wrapperFeatures.gtk = true;
    };
    fish = {
      enable = true;
      useBabelfish = true;
    };
    htop.enable = true;
    iftop.enable = true;
    iotop.enable = true;
    mtr.enable = true;
    nano.syntaxHighlight = false;
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
    pki.caCertificateBlacklist = [
      "CFCA EV ROOT"
      "TrustCor ECA-1"
      "TrustCor RootCert CA-1"
      "TrustCor RootCert CA-2"
      "vTrus ECC Root CA"
      "vTrus Root CA"
    ];
    rtkit.enable = true;
    sudo.extraConfig = ''Defaults lecture="never"'';
  };

  services = {
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
    age = {
      keyFile = "/var/lib/sops.key";
      sshKeyPaths = [ ];
    };
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
