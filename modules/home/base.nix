{ config, pkgs, ... }:

{
  # avoid creating
  # ~/.config/fontconfig/conf.d/10-hm-fonts.conf
  # ~/.config/fontconfig/conf.d/52-hm-default-fonts.conf
  fonts.fontconfig.enable = false;

  home = {
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

      # Rust
      cargo
      clippy
      rustc
      rustfmt

      # GUI
      obsidian
      okular
      telegram-desktop

      # CLI
      brightnessctl
      dmlive
      hyperfine
      kubectl
      libfaketime
      minikube
      nix-index-with-db
      nix-tree
      rename
      tealdeer
      tokei
      translate-shell
      unar
      wl-clipboard
      xdg-utils

      # TUI
      bluetuith
      impala
    ];
    sessionVariables.CARGO_HOME = "${config.xdg.cacheHome}/cargo";
    stateVersion = "24.11";
    username = "one6th";
  };

  programs = {
    bash = {
      enable = true;
      historyFile = "${config.xdg.stateHome}/bash_history";
    };
    direnv = {
      config.global.hide_env_diff = true;
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
          line-numbers = true;
          navigate = true;
        };
      };
      enable = true;
      extraConfig = {
        commit.gpgSign = true;
        diff = {
          colorMoved = "default";
          sopsdiffer.textconv = "sops -d";
        };
        gpg = {
          ssh.allowedSignersFile = builtins.toString (
            pkgs.writeText "allowed_signers" ''
              ${config.programs.git.userEmail} ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAHOSqODpw3my6PkhWrAD/sulDNCiNjKqLjNOtFPMFwr
              ${config.programs.git.userEmail} sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIFo0aSRnBTZxloY4B3UBOtuRJVEKjs5qgjKerAB2sSr7AAAABHNzaDo=
            ''
          );
          format = "ssh";
        };
        init.defaultBranch = "master";
        log.date = "iso";
        user.signingKey = "${config.home.homeDirectory}/.ssh/id_ed25519_sk_rk";
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
        cookies-from-browser = "firefox";
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
    avizo.enable = true;
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
    mpris-proxy.enable = true;
  };

  # app-org.fcitx.Fcitx5@autostart.service
  systemd.user.targets.hyprland-session.Unit.Wants = [ "xdg-desktop-autostart.target" ];
}
