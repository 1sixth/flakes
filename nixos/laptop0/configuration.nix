{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [ ./hardware.nix ];

  boot = {
    binfmt.emulatedSystems = [ "aarch64-linux" ];
    kernelModules = [ "nvidia_uvm" ];
    supportedFilesystems = [ "ntfs" ];
  };

  environment = {
    etc."nixos/flake.nix".source = "${config.users.users.one6th.home}/Develop/flakes/flake.nix";
    localBinInPath = true;
    persistence."/persistent/impermanence".users.one6th.directories = [
      ".cache/cargo"
      ".cache/go"
      ".cache/go-build"
      ".cache/nix"
      ".cache/pypoetry"
      ".cache/tealdeer"
      ".config/fcitx5"
      ".config/htop"
      ".config/Mumble"
      ".config/nali"
      ".config/rclone"
      ".config/sops"
      ".config/VSCodium"
      ".config/wireshark"
      ".local/bin"
      ".local/share/containers"
      ".local/share/direnv"
      ".local/share/fcitx5"
      ".local/share/fish"
      ".local/share/Mumble"
      ".local/share/nali"
      ".local/share/okular"
      ".local/share/org.localsend.localsend_app"
      ".local/share/PrismLauncher"
      ".local/share/TelegramDesktop"
      ".local/share/virtualenv"
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
    sessionVariables.VK_DRIVER_FILES = "/run/opengl-driver/share/vulkan/icd.d/nvidia_icd.x86_64.json";
  };

  fonts = {
    enableDefaultPackages = false;
    packages = with pkgs; [
      (iosevka-bin.override { variant = "SGr-IosevkaFixedSlab"; })
      (nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" ]; })
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-color-emoji
      noto-fonts-extra
      noto-fonts-monochrome-emoji
    ];
  };

  hardware = {
    bluetooth = {
      enable = true;
      settings.General.Experimental = true;
    };
    graphics.extraPackages = with pkgs; [ intel-media-driver ];
    nvidia = {
      modesetting.enable = true;
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
    enable = true;
    fcitx5 = {
      addons = with pkgs; [
        fcitx5-pinyin-moegirl
        fcitx5-pinyin-zhwiki
        qt6Packages.fcitx5-chinese-addons
      ];
      plasma6Support = true;
    };
    type = "fcitx5";
  };

  networking = {
    hostName = "laptop0";
    wireless.iwd.enable = true;
  };

  nix = {
    daemonCPUSchedPolicy = "idle";
    daemonIOSchedClass = "idle";
    settings = {
      builders-use-substitutes = true;
      keep-outputs = true;
      trusted-users = [
        "@wheel"
        "root"
      ];
    };
  };

  nixpkgs.config = {
    allowUnfreePredicate =
      pkg:
      builtins.elem (lib.getName pkg) [
        "cuda_cccl"
        "cuda_cudart"
        "cuda_nvcc"
        "fcitx5-pinyin-moegirl"
        "libcublas"
        "nvidia-x11"
      ];
    cudaSupport = true;
  };

  programs = {
    adb.enable = true;
    hyprland.enable = true;
    localsend.enable = true;
    ssh.extraConfig = ''
      CanonicalDomains 9875321.xyz
      CanonicalizeHostname always
      Compression yes
      ProxyCommand ${pkgs.netcat}/bin/nc -n -x 127.0.0.1:1080 %h %p
      ServerAliveInterval 10

      Host *.9875321.xyz
        User root
    '';
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
        enable = true;
        settings = {
          authfile = config.sops.secrets.u2f_keys.path;
          cue = true;
        };
      };
    };
    rtkit.enable = true;
    sudo.extraConfig = ''Defaults lecture="never"'';
  };

  services = {
    getty.autologinUser = "one6th";
    logind = {
      lidSwitch = "ignore";
      suspendKey = "ignore";
      suspendKeyLongPress = "ignore";
    };
    nextjs-ollama-llm-ui = {
      enable = true;
      ollamaUrl = "http://127.0.0.1:11434";
    };
    ollama = {
      enable = true;
      environmentVariables = {
        HTTP_PROXY = "http://127.0.0.1:1080";
        HTTPS_PROXY = "http://127.0.0.1:1080";
      };
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
    xserver.videoDrivers = [ "nvidia" ];
  };

  systemd = {
    network.networks.default.matchConfig.Type = "wlan";
    tmpfiles.rules = [ "d /mnt 755 one6th users" ];
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
      extraGroups = [
        "adbusers"
        "input"
        "podman"
        "wheel"
        "wireshark"
      ];
      hashedPasswordFile = config.sops.secrets.password_one6th.path;
      shell = pkgs.fish;
    };
    root.hashedPasswordFile = config.sops.secrets.password_root.path;
  };

  virtualisation.podman.enable = true;
}
