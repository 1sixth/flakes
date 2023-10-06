{ config, inputs, pkgs, ... }:

{
  imports = [ ./hardware.nix ];

  boot = {
    binfmt.emulatedSystems = [ "aarch64-linux" ];
    supportedFilesystems = [ "ntfs" ];
  };

  environment = {
    etc."nixos/flake.nix".source = "${config.users.users.one6th.home}/Develop/flakes/flake.nix";
    localBinInPath = true;
    persistence."/persistent/impermanence".users.one6th.directories = [
      ".cache/cargo"
      ".cache/go"
      ".cache/gradle"
      ".cache/go-build"
      ".cache/nix"
      ".cache/JetBrains"
      ".config/easyeffects"
      ".config/fcitx5"
      ".config/htop"
      ".config/JetBrains"
      ".config/nali"
      ".config/rclone"
      ".config/sops"
      ".config/VSCodium"
      ".config/wireshark"
      ".dotnet"
      ".java"
      ".local/bin"
      ".local/share/containers"
      ".local/share/direnv"
      ".local/share/fcitx5"
      ".local/share/fish"
      ".local/share/JetBrains"
      ".local/share/nali"
      ".local/share/okular"
      ".local/share/TelegramDesktop"
      ".local/share/zoxide"
      ".local/state/mpv/watch_later"
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

  fonts = {
    enableDefaultPackages = false;
    packages = with pkgs; [
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
    settings.General.Experimental = true;
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
      fcitx5-pinyin-moegirl
      fcitx5-pinyin-zhwiki
    ];
  };

  networking = {
    hostName = "laptop0";
    wireless.iwd.enable = true;
  };

  nix = {
    daemonCPUSchedPolicy = "idle";
    daemonIOSchedClass = "idle";
    registry.flake-utils.flake = inputs.flake-utils;
    settings = {
      builders-use-substitutes = true;
      keep-outputs = true;
      substituters = [ "https://mirrors.bfsu.edu.cn/nix-channels/store" ];
      trusted-users = [ "@wheel" "root" ];
    };
  };

  programs = {
    adb.enable = true;
    hyprland.enable = true;
    starship.settings.cmd_duration.show_notifications = true;
    wireshark = {
      enable = true;
      package = pkgs.wireshark;
    };
  };

  security = {
    pam = {
      services.swaylock = { };
      u2f = {
        authFile = config.sops.secrets.u2f_keys.path;
        cue = true;
        enable = true;
      };
    };
    rtkit.enable = true;
    sudo.extraConfig = ''Defaults lecture="never"'';
  };

  services = {
    getty.autologinUser = "one6th";
    logind = {
      lidSwitchExternalPower = "ignore";
      powerKey = "ignore";
      suspendKey = "ignore";
      suspendKeyLongPress = "suspend";
    };
    pipewire = {
      enable = true;
      pulse.enable = true;
    };
    tlp = {
      enable = true;
      settings = {
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      };
    };
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
      extraGroups = [ "adbusers" "input" "podman" "wheel" "wireshark" ];
      hashedPasswordFile = config.sops.secrets.password_one6th.path;
      shell = pkgs.fish;
    };
    root.hashedPasswordFile = config.sops.secrets.password_root.path;
  };

  virtualisation.podman.enable = true;
}
