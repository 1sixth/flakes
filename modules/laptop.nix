{
  config,
  pkgs,
  ...
}:

{
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
      ".cache/go-build"
      ".cache/nix"
      ".cache/tealdeer"
      ".config/fcitx5"
      ".config/htop"
      ".config/nali"
      ".config/obsidian"
      ".config/rclone"
      ".config/sops"
      ".config/syncthing"
      ".config/VSCodium"
      ".config/wireshark"
      ".continue"
      ".local/bin"
      ".local/share/containers"
      ".local/share/direnv"
      ".local/share/fcitx5"
      ".local/share/fish"
      ".local/share/nali"
      ".local/share/okular"
      ".local/share/org.localsend.localsend_app"
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

  hardware.bluetooth = {
    enable = true;
    settings.General.Experimental = true;
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
  };

  networking.wireless.iwd.enable = true;

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

  nix = {
    daemonCPUSchedPolicy = "idle";
    daemonIOSchedClass = "idle";
    settings = {
      builders-use-substitutes = true;
      keep-outputs = true;
      substituters = [
        "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
        "https://mirrors.ustc.edu.cn/nix-channels/store"
      ];
      trusted-users = [
        "@wheel"
        "root"
      ];
    };
  };

  # forgive me Stallman senpai
  nixpkgs.config.allowUnfree = true;

  programs = {
    adb.enable = true;
    hyprland.enable = true;
    hyprlock.enable = true;
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
    pam.u2f = {
      enable = true;
      settings = {
        authfile = config.sops.secrets.u2f_keys.path;
        cue = true;
      };
    };
    rtkit.enable = true;
    sudo.extraConfig = ''Defaults lecture="never"'';
  };

  services = {
    getty.autologinUser = "one6th";
    hypridle.enable = true;
    pipewire = {
      enable = true;
      pulse.enable = true;
    };
    syncthing = {
      dataDir = config.users.users.one6th.home;
      enable = true;
      group = config.users.users.one6th.group;
      overrideDevices = false;
      overrideFolders = false;
      settings.options.urAccepted = -1;
      user = "one6th";
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
    services.syncthing.after = [ "sing-box.service" ];
    tmpfiles.rules = [ "d /mnt 755 one6th users" ];
  };

  users.users.one6th = {
    extraGroups = [
      "adbusers"
      "podman"
      "wheel"
      "wireshark"
    ];
    isNormalUser = true;
    shell = pkgs.fish;
  };

  virtualisation.podman.enable = true;
}
