{ config, pkgs, ... }:

{
  imports = [
    ./browser.nix
    ./foot.nix
    ./mpv.nix
    ./neovim.nix
    ./shell.nix
    ./vscodium.nix
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
      clang-tools_16
      clang_16
      delve
      dmlive
      go-tools
      go
      gopls
      gotools
      jetbrains.idea-community
      jetbrains.pycharm-community
      libarchive
      libnotify
      nali
      nix-index-with-db
      nix-tree
      podman-compose
      poetry
      python3
      tdesktop
      translate-shell
      unar
      wl-clipboard
      xdg-utils
    ];
    sessionVariables = {
      CARGO_HOME = "${config.xdg.cacheHome}/cargo";

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
  };
}
