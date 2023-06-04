{ config, inputs, pkgs, ... }:

{
  imports = [
    inputs.hyprland.homeManagerModules.default
    ./browser.nix
    ./foot.nix
    ./hyprland.nix
    ./mpv.nix
    ./neovim.nix
    ./shell.nix
    ./theme.nix
    ./vscodium.nix
    ./waybar.nix
    ./xdg.nix
  ];

  home = {
    file = {
      "${config.xdg.stateHome}/gnupg/dirmngr.conf".text = ''
        honor-http-proxy
        keyserver hkps://keys.openpgp.org
      '';
      ".iftoprc".text = ''
        dns-resolution: no
        port-display: on
        port-resolution: no
      '';
    };
    homeDirectory = "/home/one6th";
    packages = with pkgs; [
      (pkgs.writeShellScriptBin "gnome-terminal" ''
        foot "$@"
      '')
      clang-tools
      dmlive
      fd
      file
      gcc
      gdb
      imv
      jetbrains.idea-community
      jetbrains.pycharm-community
      ldns
      libarchive
      libnotify
      libreoffice
      nali
      nix-tree
      okular
      podman-compose
      poetry
      python3
      rclone
      ripgrep
      rsync
      sshfs
      tdesktop
      translate-shell
      unar
      wl-clipboard
      xdg-utils
      yt-dlp
    ];

    sessionVariables = {
      CARGO_HOME = "${config.xdg.cacheHome}/cargo";

      LESSHISTFILE = "${config.xdg.stateHome}/lesshst";

      NVD_BACKEND = "direct";

      WLR_NO_HARDWARE_CURSORS = 1;
    };
    stateVersion = "22.05";
    username = "one6th";
  };

  programs = {
    aria2.enable = true;
    bash = {
      enable = true;
      historyFile = "${config.xdg.stateHome}/bash_history";
    };
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    exa.enable = true;
    fzf.enable = true;
    git = {
      delta = {
        enable = true;
        options = {
          light = true;
          line-numbers = true;
        };
      };
      enable = true;
      extraConfig = {
        "diff \"sopsdiffer\"".textconv = "sops -d";
        commit.gpgSign = true;
        gpg = {
          ssh.allowedSignersFile = builtins.toString (pkgs.writeText "allowed_signers"
            (config.programs.git.userEmail + " " + config.programs.git.extraConfig.user.signingKey));
          format = "ssh";
        };
        init.defaultBranch = "master";
        log.date = "iso";
        user.signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAHOSqODpw3my6PkhWrAD/sulDNCiNjKqLjNOtFPMFwr";
      };
      userEmail = "1sixth@shinta.ro";
      userName = "1sixth";
    };
    gpg = {
      enable = true;
      homedir = "${config.xdg.stateHome}/gnupg";
    };
    home-manager.enable = true;
    jq.enable = true;
    keychain = {
      enable = true;
      keys = [ "id_ed25519" ];
    };
    lf = {
      enable = true;
      keybindings = {
        "<c-c>" = "copy";
        "<c-x>" = "cut";
        "<c-v>" = "paste";
        "<delete>" = "delete";
        "<enter>" = "open";
        "<f-2>" = "rename";
        d = "delete";
      };
      settings = {
        preview = false;
        ratios = "1:2";
      };
    };
    nix-index = {
      enable = true;
      enableFishIntegration = false;
    };
    ssh = {
      compression = true;
      enable = true;
      matchBlocks = {
        "*" = {
          extraOptions = {
            CanonicalDomains = "9875321.xyz";
            CanonicalizeHostname = "always";
          };
          proxyCommand = "nc -n -x 127.0.0.1:1080 %h %p";
        };
        "*.9875321.xyz".user = "root";
      };
      serverAliveInterval = 10;
    };
    swaylock = {
      enable = true;
      settings = {
        daemonize = true;
        image = builtins.toString (pkgs.fetchurl {
          url = "https://upload.wikimedia.org/wikipedia/commons/a/a3/Crimea%2C_Ai-Petri%2C_low_clouds.jpg";
          hash = "sha256-ZiRdkGZDAINRePRrE72GdM1C/AtQU+r3gK/Jt+fSrtA=";
        });
        indicator-caps-lock = true;
        indicator-idle-visible = true;
        scaling = "fill";
        show-failed-attempts = true;
      };
    };
    thunderbird = {
      enable = true;
      package = pkgs.thunderbird.override {
        extraPolicies = {
          Proxy = {
            Mode = "manual";
            SOCKSProxy = "127.0.0.1:1080";
            SOCKSVersion = 5;
            UseProxyForDNS = true;
          };
        };
      };
      profiles.default.isDefault = true;
    };
    wofi = {
      enable = true;
      settings = {
        insensitive = true;
        layer = "overlay";
        show = "drun";
      };
      style = builtins.readFile ./res/wofi.css;
    };
    yt-dlp = {
      enable = true;
      settings = {
        embed-chapters = true;
        extractor-args = "youtube:skip=translated_subs";
        output = "$PWD/%(title)s.%(ext)s";
        remux-video = "mkv";
        sub-langs = "en.*,zh.*";
        write-subs = true;
        write-auto-subs = true;
      };
    };
  };

  services = {
    easyeffects.enable = true;
    gpg-agent = {
      enable = true;
      enableFishIntegration = false;
      pinentryFlavor = "curses";
    };
    mako = {
      anchor = "bottom-right";
      defaultTimeout = 6180;
      enable = true;
      font = "${config.gtk.font.name} ${builtins.toString config.gtk.font.size}";
      height = 200;
      layer = "overlay";
      width = 300;
    };
    swayidle = {
      enable = true;
      events = [{
        command = "${config.programs.swaylock.package}/bin/swaylock";
        event = "lock";
      }];
      timeouts = [
        {
          command = "${pkgs.systemd}/bin/loginctl lock-session";
          timeout = 300;
        }
        {
          command = "${pkgs.hyprland}/bin/hyprctl dispatch dpms off";
          timeout = 305;
        }
      ];
      systemdTarget = "hyprland-session.target";
    };
  };

  systemd.user = {
    services.sshfs = {
      Unit.After = [ "network-online.target" ];
      Service = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = builtins.toString (pkgs.writeShellScript "sshfs-start.sh" ''
          ${pkgs.sshfs}/bin/sshfs -o idmap=user,reconnect nas:/persistent/16T /persistent/16T
          ${pkgs.sshfs}/bin/sshfs -o idmap=user,reconnect nas:/persistent/8T /persistent/8T
        '');
        ExecStop = builtins.toString (pkgs.writeShellScript "sshfs-stop.sh" ''
          /run/wrappers/bin/umount /persistent/16T
          /run/wrappers/bin/umount /persistent/8T
        '');
      };
    };
    targets.hyprland-session.Unit.Wants = [ "xdg-desktop-autostart.target" ];
  };
}
