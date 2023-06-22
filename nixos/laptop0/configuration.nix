{ config, inputs, pkgs, ... }:

{
  imports = [ ./hardware.nix ];

  boot = {
    binfmt.emulatedSystems = [ "aarch64-linux" ];
    kernelParams = [ "amd_pstate=active" ];
    supportedFilesystems = [ "ntfs" ];
  };

  environment = {
    etc."nixos/flake.nix".source = "${config.users.users.one6th.home}/Develop/flakes/flake.nix";
    persistence."/persistent/impermanence".users.one6th.directories = [
      { directory = ".local/state/gnupg"; mode = "0700"; }
      ".cache/cargo"
      ".cache/JetBrains"
      ".cache/nix"
      ".cache/pypoetry"
      ".config/easyeffects"
      ".config/fcitx5"
      ".config/htop"
      ".config/JetBrains"
      ".config/mpv/watch_later"
      ".config/nali"
      ".config/rclone"
      ".config/sops"
      ".config/VSCodium"
      ".java"
      ".local/share/containers"
      ".local/share/direnv"
      ".local/share/fcitx5"
      ".local/share/fish"
      ".local/share/JetBrains"
      ".local/share/nali"
      ".local/share/okular"
      ".local/share/sponsorblock_shared"
      ".local/share/TelegramDesktop"
      ".local/share/virtualenv"
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
      trusted-users = [ "@wheel" "root" ];
    };
  };

  programs = {
    adb.enable = true;
    hyprland = {
      enable = true;
      package = pkgs.hyprland;
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
    network = {
      enable = true;
      networks.default.matchConfig.Type = "wlan";
    };
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
      extraGroups = [ "adbusers" "podman" "wheel" ];
      passwordFile = config.sops.secrets.password_one6th.path;
      shell = pkgs.fish;
    };
    root.passwordFile = config.sops.secrets.password_root.path;
  };

  virtualisation.podman.enable = true;

  zramSwap.enable = true;
}
