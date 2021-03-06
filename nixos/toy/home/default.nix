{ config, pkgs, ... }:

let
  wallpaper = pkgs.fetchurl {
    curlOpts = "--referer https://www.pixiv.net";
    url = "https://i.pximg.net/img-original/img/2017/04/21/18/35/04/62506385_p0.jpg";
    sha256 = "sha256-B1/J9ReWB0AD2pDxVsRcJ/naFOX+Tx4gDihUp1QLsvA=";
  };
in

{
  imports = [
    ./browser.nix
    ./foot.nix
    ./mpv.nix
    ./neovim.nix
    ./sway.nix
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
      age
      cargo
      clang
      clang-tools
      crow-translate
      deploy-rs.deploy-rs
      fd
      file
      gotop
      htop
      imv
      iotop
      jetbrains.pycharm-community
      ldns # drill is awesome
      libarchive # bsdtar is awesome
      libsForQt5.qtstyleplugin-kvantum # for qt theme
      mumble
      onlyoffice-bin
      pandoc
      pcmanfm-qt
      poetry
      polymc
      python3
      rclone
      restic
      ripgrep
      rnix-lsp
      rsync
      rustc
      rustfmt
      sequoia
      sops
      sshfs
      tdesktop
      thunderbird
      unar # to handle some non UTF-8 encoded archives
      wl-clipboard
      xdg-utils
      yt-dlp
    ];

    sessionVariables = {
      fish_greeting = "";

      EDITOR = "nvim";

      LESSHISTFILE = "${config.xdg.stateHome}/lesshst";

      # PyCharm will break without this.
      _JAVA_AWT_WM_NONREPARENTING = 1;

      CARGO_HOME = "${config.xdg.dataHome}/cargo";
      RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";

      # https://gist.github.com/foutrelis/14e339596b89813aa9c37fd1b4e5d9d5
      GOOGLE_DEFAULT_CLIENT_ID = "77185425430.apps.googleusercontent.com";
      GOOGLE_DEFAULT_CLIENT_SECRET = "OTJgUOQcT7lO7GsGZq2G4IlT";
    };
    stateVersion = "22.05";
    username = "one6th";
  };

  programs = {
    bash = {
      enable = true;
      historyFile = "${config.xdg.stateHome}/bash_history";
    };
    exa.enable = true;
    fish = {
      enable = true;
      # https://github.com/swaywm/sway/wiki#login-managers
      interactiveShellInit = "[ (tty) = /dev/tty1 ] && exec sway";
      shellAliases = {
        l = "ll -a";
        ll = "ls -l -g --time-style=long-iso";
        ls = "exa --group-directories-first";
        tree = "ls -T";

        sys = "sudo systemctl";
        sysu = "systemctl --user";

        jou = "journalctl";
        jouu = "journalctl --user";

        t = "crow -s en -t zh-CN";

        nixos-rebuild = "nixos-rebuild --use-remote-sudo";
      };
    };
    git = {
      difftastic.enable = true;
      enable = true;
      extraConfig = {
        init.defaultBranch = "master";
        log.date = "iso";
      };
      signing = {
        signByDefault = true;
        key = "91173A04457B40A1CBF42221ED2A3FFD509AA5CC";
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
    lf = {
      enable = true;
      settings = {
        preview = false;
        ratios = "1:2";
      };
    };
    mako = {
      anchor = "bottom-right";
      defaultTimeout = 6180;
      enable = true;
      font = "${config.gtk.font.name} ${builtins.toString config.gtk.font.size}";
      layer = "overlay";
    };
    nix-index.enable = true;
    ssh = {
      compression = true;
      enable = true;
      # https://wiki.archlinux.org/title/GnuPG#Configure_pinentry_to_use_the_correct_TTY
      # https://lists.gnupg.org/pipermail/gnupg-users/2017-June/058581.html
      extraConfig = ''Match host * exec "gpg-connect-agent UPDATESTARTUPTTY /bye"'';
      matchBlocks = {
        "*".proxyCommand = "nc -x 127.0.0.1:1080 %h %p";
        "*.9875321.xyz".user = "root";
        "box" = {
          hostname = "u307841.your-storagebox.de";
          port = 23;
          user = "u307841";
        };
      };
      serverAliveInterval = 10;
    };
    starship = {
      enable = true;
      settings.add_newline = false;
    };
    swaylock.settings = {
      clock = true;
      daemonize = true;
      effect-blur = "7x5";
      effect-vignette = "0.5:0.5";
      grace = 3;
      image = wallpaper.outPath;
      indicator-caps-lock = true;
      scaling = "fill";
      show-failed-attempts = true;
    };
  };

  services = {
    gpg-agent = {
      enable = true;
      enableSshSupport = true;
      pinentryFlavor = "curses";
      sshKeys = [ "56F5EC024AAE01E143592C7B21F60902660B203D" ];
    };
    kanshi = {
      enable = true;
      profiles = {
        # Negative coordinates break VSCodium under XWayland.
        # I have not tested it under native Wayland yet.
        # Other Electron apps works fine under XWayland.
        # Chromium works fine under XWayland and native Wayland.
        left.outputs = [
          { criteria = "HDMI-A-1"; position = "0,0"; }
          { criteria = "eDP-1"; position = "1920,0"; }
        ];
      };
    };
    swayidle = {
      enable = true;
      events = [{
        command = "${pkgs.swaylock-effects}/bin/swaylock";
        event = "lock";
      }];
      timeouts = [
        {
          command = "loginctl lock-session";
          timeout = 300;
        }
        {
          command = ''swaymsg "output * dpms off"'';
          resumeCommand = ''swaymsg "output * dpms on"'';
          timeout = 600;
        }
      ];
    };
    wlsunset = {
      enable = true;
      latitude = "0";
      longitude = "120";
    };
  };

  systemd.user = {
    # https://github.com/emersion/mako/blob/master/contrib/systemd/mako.service
    services.mako = {
      Install.WantedBy = [ "graphical-session.target" ];
      Service = {
        Type = "dbus";
        BusName = "org.freedesktop.Notifications";
        ExecCondition = "/bin/sh -c '[ -n $WAYLAND_DISPLAY ]'";
        ExecStart = "${pkgs.mako}/bin/mako";
        ExecReload = "${pkgs.mako}/bin/makoctl reload";
      };
      Unit = {
        After = "graphical-session.target";
        Description = "Lightweight Wayland notification daemon";
        Documentation = "man:mako(1)";
        PartOf = "graphical-session.target";
      };
    };
    targets.sway-session.Unit.Wants = [ "xdg-desktop-autostart.target" ];
  };

  # TODO: Figure out what to do with the wallpaper.
  wayland.windowManager.sway.config.output."*".bg = "${wallpaper} fill";
}
