{
  config,
  pkgs,
  self,
  ...
}:

{
  imports = [ ./overlays.nix ];

  boot.supportedFilesystems = [ "ntfs" ];

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
      ".kube"
      ".local/bin"
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
      ".minikube"
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
    extraSpecialArgs = {
      inherit self;
    };
    useGlobalPkgs = true;
    useUserPackages = true;
  };

  networking.wireless.iwd.enable = true;

  i18n.inputMethod = {
    enable = true;
    fcitx5 = {
      addons = with pkgs; [
        fcitx5-chinese-addons
        fcitx5-pinyin-moegirl
        fcitx5-pinyin-zhwiki
      ];
    };
    type = "fcitx5";
  };

  nix = {
    daemonCPUSchedPolicy = "idle";
    daemonIOSchedClass = "idle";
    settings = {
      builders-use-substitutes = true;
      keep-outputs = true;
      # When free disk space drops below min-free during a build,
      # perform a garbage-collection until max-free bytes are
      # available or there is no more garbage.
      max-free = (20 * 1024 * 1024 * 1024);
      min-free = (10 * 1024 * 1024 * 1024);
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
    # Behavior:
    # `ssh lax0`: routed via tailscale
    # `ssh lax0.tail5e6002.ts.net`: routed via tailscale
    # `ssh lax0.9875321.xyz`: direct, this is used by colmena
    # `ssh lax0.9875321.xyz -p 2222`: proxied via sing-box, just in case
    # `ssh -T git@github.com`: proxied via sing-box
    ssh.extraConfig = ''
      CanonicalDomains tail5e6002.ts.net
      CanonicalizeHostname always
      Compression yes
      ServerAliveInterval 10

      Host *.9875321.xyz *.tail5e6002.ts.net
        User root

      Host *.tail5e6002.ts.net
        ProxyCommand none

      # This matches any host that contains at least 1 dot.
      Host *.*
        ProxyCommand ${pkgs.netcat}/bin/nc -n -x 127.0.0.1:1080 %h %p
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
    keyd = {
      enable = true;
      keyboards.default = {
        ids = [ "*" ];
        settings.main.capslock = "leftcontrol";
      };
    };
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
      "docker"
      "input" # waybar keyboard-state module
      "wheel"
      "wireshark"
    ];
    isNormalUser = true;
    shell = pkgs.fish;
  };

  virtualisation.docker = {
    autoPrune.enable = true;
    daemon.settings.log-driver = "journald";
    enable = true;
  };
}