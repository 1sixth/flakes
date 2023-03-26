{ config, inputs, lib, pkgs, ... }:

{
  imports = [ ./hardware.nix ];

  boot = {
    binfmt.emulatedSystems = [ "aarch64-linux" ];
    kernelParams = [ "amd_pstate=passive" ];
    supportedFilesystems = [ "ntfs" ];
  };

  console.font = null;

  environment = {
    etc."nixos/flake.nix".source = "${config.users.users.one6th.home}/Develop/flakes/flake.nix";
    persistence."/persistent/impermanence".users.one6th.directories = [
      { directory = ".local/state/gnupg"; mode = "0700"; }
      ".cache/cargo"
      ".cache/nix"
      ".cache/nix-index"
      ".cache/pypoetry"
      ".config/easyeffects"
      ".config/fcitx5"
      ".config/htop"
      ".config/mpv/watch_later"
      ".config/nali"
      ".config/rclone"
      ".config/sops"
      ".config/VSCodium"
      ".config/wireshark"
      ".local/share/containers"
      ".local/share/direnv"
      ".local/share/fcitx5"
      ".local/share/fish"
      ".local/share/kxmlgui5/okular"
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

  hardware = {
    bluetooth.enable = true;
    nvidia = {
      nvidiaSettings = false;
      open = true;
      powerManagement.enable = true;
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
    hostName = "toy";
    wireless.iwd.enable = true;
  };

  nix.settings = {
    builders-use-substitutes = true;
    keep-derivations = true;
    keep-outputs = true;
    substituters = [
      "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
    ];
  };

  nix.registry.flake-utils.flake = inputs.flake-utils;

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "nvidia-x11"
    "vscode-extension-MS-python-vscode-pylance"
  ];

  powerManagement.cpuFreqGovernor = "schedutil";

  programs = {
    adb.enable = true;
    sway = {
      enable = true;
      extraOptions = [
        "--unsupported-gpu"
      ];
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
    xserver.videoDrivers = [ "nvidia" ];
  };

  systemd = {
    network = {
      networks = {
        default.matchConfig.Type = "ether";
        wlan = {
          DHCP = "yes";
          matchConfig.Type = "wlan";
        };
      };
      wait-online.anyInterface = true;
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
      extraGroups = [ "adbusers" "podman" "wheel" "wireshark" ];
      passwordFile = config.sops.secrets.password_one6th.path;
      shell = pkgs.fish;
    };
    root.passwordFile = config.sops.secrets.password_root.path;
  };

  virtualisation.podman = {
    dockerSocket.enable = true;
    enable = true;
  };
}
