{ config, inputs, lib, pkgs, ... }:

{
  imports = [ ./hardware.nix ];

  boot = {
    binfmt.emulatedSystems = [ "aarch64-linux" ];
    supportedFilesystems = [ "ntfs" ];
  };

  environment = {
    etc."nixos/flake.nix".source = "${config.users.users.one6th.home}/Develop/flakes/flake.nix";
    persistence."/persistent/impermanence".users.one6th.directories = [
      { directory = ".local/state/gnupg"; mode = "0700"; }
      ".cache/cargo"
      ".cache/nix"
      ".cache/pypoetry"
      ".config/chromium"
      ".config/easyeffects"
      ".config/fcitx5"
      ".config/htop"
      ".config/mpv/watch_later"
      ".config/nali"
      ".config/rclone"
      ".config/sops"
      ".config/VSCodium"
      ".local/share/containers"
      ".local/share/direnv"
      ".local/share/fcitx5"
      ".local/share/fish"
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
    registry.flake-utils.flake = inputs.flake-utils;
    settings = {
      builders-use-substitutes = true;
      keep-derivations = true;
      keep-outputs = true;
    };
  };

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "chrome-widevine-cdm"
    "chromium-unwrapped"
    "ungoogled-chromium"
    "vscode-extension-MS-python-vscode-pylance"
  ];

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
    sudo.extraConfig = ''Defaults lecture="never"'';
  };

  services = {
    getty.autologinUser = "one6th";
    logind.lidSwitch = "ignore";
    pipewire = {
      enable = true;
      pulse.enable = true;
    };
  };

  systemd = {
    network = {
      enable = true;
      networks = {
        wlan = {
          DHCP = "yes";
          matchConfig.Type = "wlan";
        };
      };
      wait-online.enable = false;
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
}
