{ config, inputs, pkgs, ... }:

{
  imports = [ ./hardware.nix ];

  boot = {
    binfmt.emulatedSystems = [ "aarch64-linux" ];
    supportedFilesystems = [ "ntfs" ];
  };

  environment = {
    etc."nixos/flake.nix".source = "${config.users.users.one6th.home}/Develop/flakes/flake.nix";
    persistence."/persistent/impermanence" = {
      directories = [
        "/tmp"
      ];
      users.one6th.directories = [
        ".cache/nix"
        ".cache/nix-index"
        ".cache/pypoetry"
        ".config/fcitx5"
        ".config/htop"
        ".config/JetBrains"
        ".config/mpv/watch_later"
        ".config/nali"
        ".config/rclone"
        ".config/VSCodium"
        ".config/wireshark"
        ".local/share/cargo"
        ".local/share/fcitx5"
        ".local/share/fish"
        ".local/share/JetBrains"
        ".local/share/kxmlgui5/okular"
        ".local/share/nali"
        ".local/share/okular"
        ".local/share/TelegramDesktop"
        ".local/share/virtualenv"
        ".local/state/gnupg"
        ".local/state/nvim"
        ".local/state/wireplumber"
        ".mozilla"
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
    hostName = "toy";
    wireless.iwd.enable = true;
  };

  nixpkgs.overlays = [
    inputs.colmena.overlay
  ];

  powerManagement.cpuFreqGovernor = "schedutil";

  programs = {
    adb.enable = true;
    sway = {
      enable = true;
      wrapperFeatures.gtk = true;
    };
    wireshark = {
      enable = true;
      package = pkgs.wireshark;
    };
  };

  security = {
    pam.u2f = {
      authFile = config.sops.secrets.u2f_keys.path;
      cue = true;
      enable = true;
    };
    sudo.extraConfig = ''Defaults lecture="never"'';
  };

  services = {
    getty.autologinUser = "one6th";
    logind.lidSwitch = "ignore";
    pipewire = {
      enable = true;
      pulse.enable = true;
    };
    tlp.enable = true;
    upower.enable = true;
  };

  systemd = {
    network.networks.default.matchConfig.Type = "wlan";
    tmpfiles.rules = [
      "d /mnt 755 one6th users"
    ];
  };

  sops = {
    defaultSopsFile = ./secrets.yaml;
    secrets = {
      password_root.neededForUsers = true;
      password_one6th.neededForUsers = true;
      u2f_keys.mode = "0444";
    };
  };

  users.users = {
    one6th = {
      isNormalUser = true;
      extraGroups = [ "adbusers" "wheel" "wireshark" ];
      passwordFile = config.sops.secrets.password_one6th.path;
      shell = pkgs.fish;
    };
    root.passwordFile = config.sops.secrets.password_root.path;
  };
}
