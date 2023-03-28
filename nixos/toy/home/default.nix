{ config, pkgs, ... }:

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
      (pkgs.writeShellScriptBin "gnome-terminal" ''
        foot "$@"
      '')
      clang_14
      clang-tools
      fd
      file
      imv
      ldns
      libreoffice
      nali
      nvtop
      okular
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
      fish_greeting = "";

      CARGO_HOME = "${config.xdg.cacheHome}/cargo";

      LESSHISTFILE = "${config.xdg.stateHome}/lesshst";

      NIXOS_OZONE_WL = 1;
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
    fish = {
      enable = true;
      functions = {
        colmena.body = ''
          switch $argv[1]
              case apply build
                  command colmena $argv --evaluator streaming --keep-result
              case "*"
                  command colmena $argv
          end
        '';
        nl.body = "nix-locate --whole-name bin/$argv";
        which.body = "readlink -f (command which $argv)";
      };
      # https://github.com/swaywm/sway/wiki#login-managers
      interactiveShellInit = ''
        [ (tty) = /dev/tty1 ] && exec sway
        set -gx GPG_TTY (tty)
      '';
      shellAliases = {
        l = "ll -a";
        ll = "ls -l -g --time-style=long-iso";
        ls = "exa --group-directories-first";
        tree = "ls -T";

        sys = "sudo systemctl";
        sysu = "systemctl --user";

        jou = "journalctl";
        jouu = "journalctl --user";

        t = "trans :zh-CN";
        ts = "trans :zh-CN -speak";

        nixos-rebuild = "nixos-rebuild --use-remote-sudo --verbose";

        nwdrc = "nix why-depends /run/current-system/";

        mpvc = "mpv --ytdl-raw-options=cookies-from-browser=firefox";
        mpvn = "mpv --ytdl-raw-options=no-write-auto-subs=";
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
      indicator = true;
      indicator-caps-lock = true;
      screenshots = true;
      show-failed-attempts = true;
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
        command = "${pkgs.swaylock-effects}/bin/swaylock";
        event = "lock";
      }];
      timeouts = [
        {
          command = "${pkgs.systemd}/bin/loginctl lock-session";
          timeout = 300;
        }
        {
          command = ''${pkgs.sway}/bin/swaymsg "output * dpms off"'';
          resumeCommand = ''${pkgs.sway}/bin/swaymsg "output * dpms on"'';
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
    targets.sway-session.Unit.Wants = [ "xdg-desktop-autostart.target" ];
  };
}
