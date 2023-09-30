{ config, pkgs, ... }:

let
  wallpaper = pkgs.fetchurl {
    url = "https://upload.wikimedia.org/wikipedia/commons/a/a3/Crimea%2C_Ai-Petri%2C_low_clouds.jpg";
    hash = "sha256-ZiRdkGZDAINRePRrE72GdM1C/AtQU+r3gK/Jt+fSrtA=";
  };
in

{
  imports = [
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

  fonts.fontconfig.enable = false;

  home = {
    file.".iftoprc".text = ''
      dns-resolution: no
      port-display: on
      port-resolution: no
    '';
    homeDirectory = "/home/one6th";
    packages = with pkgs; [
      # C#
      dotnet-sdk

      # C/C++
      clang-tools
      gcc

      # Go
      delve
      go-tools
      go
      gopls
      gotools

      # Java
      gradle

      # Python
      python3

      # Rust
      cargo
      clippy
      rustc

      # GUI
      jetbrains.idea-community
      libreoffice
      okular
      tdesktop

      # Terminal Utilities
      colmena
      dmlive
      eza
      libarchive
      nali
      nix-index-with-db
      nix-tree
      podman-compose
      sops
      tokei
      translate-shell
      unar
      wl-clipboard
      xdg-utils
    ];
    sessionVariables = {
      _JAVA_OPTIONS = "-Dsun.java2d.uiScale=2";

      CARGO_HOME = "${config.xdg.cacheHome}/cargo";

      DOTNET_CLI_TELEMETRY_OPTOUT = 1;

      GRADLE_USER_HOME = "${config.xdg.cacheHome}/gradle";

      LESSHISTFILE = "${config.xdg.stateHome}/lesshst";
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
    fuzzel = {
      enable = true;
      settings.main = {
        fields = "name";
        font = "monospace:size=20";
        fuzzy = "no";
        terminal = "${config.programs.foot.package}/bin/foot -e";
      };
    };
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
        commit.gpgSign = true;
        diff.sopsdiffer.textconv = "sops -d";
        gpg = {
          ssh.allowedSignersFile = builtins.toString (pkgs.writeText "allowed_signers" ''
            ${config.programs.git.userEmail} ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAHOSqODpw3my6PkhWrAD/sulDNCiNjKqLjNOtFPMFwr
          '');
          format = "ssh";
        };
        init.defaultBranch = "master";
        log.date = "iso";
        user.signingKey = "${config.home.homeDirectory}/.ssh/id_ed25519";
      };
      userEmail = "1sixth@shinta.ro";
      userName = "1sixth";
    };
    home-manager.enable = true;
    imv.enable = true;
    jq.enable = true;
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
        image = "${wallpaper}";
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
    yt-dlp = {
      enable = true;
      settings = {
        embed-chapters = true;
        extractor-args = "youtube:skip=translated_subs";
        output = "$PWD/%(title)s.%(ext)s";
        remux-video = "mkv";
        sub-langs = "ai-zh,en.*,zh.*";
        write-auto-subs = true;
        write-subs = true;
      };
    };
    zoxide.enable = true;
  };

  services = {
    easyeffects.enable = true;
    mako = {
      # https://github.com/stacyharper/base16-mako/blob/master/colors/base16-solarized-light.config
      anchor = "bottom-right";
      backgroundColor = "#fdf6e3";
      borderColor = "#268bd2";
      defaultTimeout = 10000;
      enable = true;
      font = "monospace 15";
      layer = "overlay";
      textColor = "#586e75";
    };
    swayidle = {
      enable = true;
      events = [{
        command = "${config.programs.swaylock.package}/bin/swaylock";
        event = "lock";
      }];
      systemdTarget = "hyprland-session.target";
      timeouts = [
        {
          command = "${pkgs.systemd}/bin/loginctl lock-session";
          timeout = 300;
        }
        {
          command = "${pkgs.hyprland}/bin/hyprctl dispatch dpms off";
          resumeCommand = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on";
          timeout = 305;
        }
      ];
    };
  };

  systemd.user.targets.hyprland-session.Unit.Wants = [ "xdg-desktop-autostart.target" ];
}
