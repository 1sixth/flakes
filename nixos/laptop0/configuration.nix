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
    localBinInPath = true;
    persistence."/persistent/impermanence".users.one6th.directories = [
      ".cache/cargo"
      ".cache/go"
      ".cache/go-build"
      ".cache/JetBrains"
      ".cache/nix"
      ".cache/pypoetry"
      ".config"
      ".java"
      ".local/bin"
      ".local/share"
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
    settings = {
      General.Experimental = true;
      Policy.ReconnectAttempts = 0;
    };
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
    dhcpcd.enable = false;
    hostName = "laptop0";
    networkmanager = {
      enable = true;
      wifi.backend = "iwd";
    };
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
    dconf.enable = true;
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
    rtkit.enable = true;
    sudo.extraConfig = ''Defaults lecture="never"'';
  };

  services = {
    pipewire = {
      enable = true;
      pulse.enable = true;
    };
    power-profiles-daemon.enable = false;
    tlp = {
      enable = true;
      settings = {
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      };
    };
    xserver = {
      desktopManager.plasma5.enable = true;
      displayManager = {
        defaultSession = "plasmawayland";
        sddm = {
          enable = true;
          settings.General.DisplayServer = "wayland";
        };
      };
      enable = true;
    };
  };

  systemd.tmpfiles.rules = [
    "d /mnt 755 one6th users"
  ];

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
      extraGroups = [ "adbusers" "networkmanager" "podman" "wheel" "wireshark" ];
      passwordFile = config.sops.secrets.password_one6th.path;
      shell = pkgs.fish;
    };
    root.passwordFile = config.sops.secrets.password_root.path;
  };

  virtualisation.podman.enable = true;

  zramSwap.enable = true;
}
