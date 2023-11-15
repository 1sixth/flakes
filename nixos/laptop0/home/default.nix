{ config, pkgs, ... }:

let
  wallpaper = pkgs.fetchurl {
    curlOpts = "--referer https://www.pixiv.net";
    url = "https://i.pximg.net/img-original/img/2017/09/30/18/37/34/65204496_p0.png";
    hash = "sha256-AenfCFlD0afOvfoIqCrUelwbgLQ8l0POwsVykLI3Ksc=";
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
      jdk17

      # Python
      poetry
      python3

      # Rust
      cargo
      clippy
      rustc

      # GUI
      jetbrains.idea-community
      jetbrains.pycharm-community
      libreoffice
      okular
      telegram-desktop
      tor-browser

      # Terminal Utilities
      colmena
      curlHTTP3
      dmlive
      eza
      libarchive
      libfaketime
      nali
      nix-index-with-db
      nix-tree
      pamixer
      podman-compose
      rename
      sops
      tealdeer
      tokei
      translate-shell
      unar
      wl-clipboard
      xdg-utils
    ];
    sessionVariables = {
      CARGO_HOME = "${config.xdg.cacheHome}/cargo";

      GRADLE_USER_HOME = "${config.xdg.cacheHome}/gradle";

      JAVA_HOME = pkgs.jdk17.home;

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
            ${config.programs.git.userEmail} sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIFo0aSRnBTZxloY4B3UBOtuRJVEKjs5qgjKerAB2sSr7AAAABHNzaDo=
          '');
          format = "ssh";
        };
        init.defaultBranch = "master";
        log.date = "iso";
        pull.rebase = true;
        user.signingKey = "${config.home.homeDirectory}/.ssh/id_ed25519_sk";
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
        extractor-args = "youtube:skip=dash,translated_subs";
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
