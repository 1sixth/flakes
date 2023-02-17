{ config, inputs, pkgs, ... }:

{
  documentation = {
    doc.enable = false;
    info.enable = false;
    man.enable = false;
  };

  environment = {
    persistence."/persistent/impermanence" = {
      directories = [
        "/root"
      ];
      files = [
        "/etc/ssh/ssh_host_ed25519_key"
        "/etc/ssh/ssh_host_ed25519_key.pub"
      ];
    };
    systemPackages = with pkgs; [
      fd
      file
      ldns
      nmap
      rclone
      ripgrep
      rsync
      screen
    ];
  };

  fonts.fontconfig.enable = false;

  i18n.supportedLocales = [ "en_US.UTF-8/UTF-8" ];

  programs = {
    fish = {
      interactiveShellInit = ''
        set -g fish_greeting

        # name: Solarized Light
        # preferred_background: fdf6e3
        # url: 'http://ethanschoonover.com/solarized'

        set -U fish_color_normal normal
        set -U fish_color_command 586e75
        set -U fish_color_quote 839496
        set -U fish_color_redirection 6c71c4
        set -U fish_color_end 268bd2
        set -U fish_color_error dc322f
        set -U fish_color_param 657b83
        set -U fish_color_comment 93a1a1
        set -U fish_color_match --background=brblue
        set -U fish_color_selection white --bold --background=brblack
        set -U fish_color_search_match bryellow --background=white
        set -U fish_color_history_current --bold
        set -U fish_color_operator 00a6b2
        set -U fish_color_escape 00a6b2
        set -U fish_color_cwd green
        set -U fish_color_cwd_root red
        set -U fish_color_valid_path --underline
        set -U fish_color_autosuggestion 93a1a1
        set -U fish_color_user brgreen
        set -U fish_color_host normal
        set -U fish_color_cancel -r
        set -U fish_pager_color_completion green
        set -U fish_pager_color_description B3A06D
        set -U fish_pager_color_prefix cyan --underline
        set -U fish_pager_color_progress brwhite --background=cyan
        set -U fish_pager_color_selected_background --background=white
        set -U fish_color_option 657b83
        set -U fish_color_keyword 586e75
        set -U fish_color_host_remote yellow
        set -U fish_color_status red
      '';
      shellAliases = {
        l = "ll -a";
        ll = "ls -l -g --time-style=long-iso";
        ls = "${pkgs.exa}/bin/exa --group-directories-first";
        tree = "ls -T";

        sys = "systemctl";

        jou = "journalctl";
      };
    };
    git.enable = true;
    neovim = {
      defaultEditor = true;
      enable = true;
      viAlias = true;
      vimAlias = true;
      withRuby = false;
    };
    starship = {
      enable = true;
      settings.add_newline = false;
    };
  };

  security.sudo.enable = false;

  services = {
    openssh = {
      enable = true;
      hostKeys = [{
        path = "/etc/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }];
      settings = {
        kbdInteractiveAuthentication = false;
        passwordAuthentication = false;
      };
    };
    traefik = {
      dynamicConfigOptions = {
        middlewares.compress.compress = { };
        tls.options.default = {
          minVersion = "VersionTLS12";
          sniStrict = true;
        };
      };
      enable = true;
      staticConfigOptions = {
        certificatesResolvers.letsencrypt.acme = {
          dnsChallenge.provider = "cloudflare";
          email = "letsencrypt@shinta.ro";
          keyType = "EC256";
          storage = "${config.services.traefik.dataDir}/acme.json";
        };
        experimental.http3 = true;
        entryPoints = {
          http = {
            address = ":80";
            http.redirections.entryPoint.to = "https";
          };
          https = {
            address = ":443";
            http.tls.certResolver = "letsencrypt";
            http3 = { };
          };
        };
      };
    };
    vnstat.enable = true;
  };

  sops = {
    secrets.cloudflare_token = {
      sopsFile = ./secrets.yaml;
      owner = config.users.users.traefik.name;
      group = config.users.users.traefik.group;
    };
    secrets.password_root = {
      neededForUsers = true;
      sopsFile = ./secrets.yaml;
    };
  };

  systemd = {
    network.networks.default.matchConfig.Type = "ether";
    services.traefik.serviceConfig.EnvironmentFile = config.sops.secrets.cloudflare_token.path;
  };

  users.users.root = {
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOnLRT5k4gZCKNaHbLg+jEsD5ZU1/V8Bh3WxiUIrB1Bu"
    ];
    passwordFile = config.sops.secrets.password_root.path;
  };
}
