{ config, inputs, lib, pkgs, ... }:

{
  boot = {
    cleanTmpDir = true;
    kernel.sysctl = {
      # https://github.com/torvalds/linux/blob/8032bf1233a74627ce69b803608e650f3f35971c/net/ipv4/tcp_bbr.c
      "net.core.default_qdisc" = "fq";
      "net.ipv4.tcp_congestion_control" = "bbr";
      # https://github.com/lucas-clemente/quic-go/wiki/UDP-Receive-Buffer-Size#non-bsd
      "net.core.rmem_max" = 2500000;
    };
    kernelPackages = pkgs.linuxPackages_latest;
  };

  documentation = {
    doc.enable = false;
    info.enable = false;
    man.enable = false;
  };

  environment = {
    defaultPackages = lib.mkForce [ ];
    systemPackages = with pkgs; [
      fd
      file
      ldns
      nmap
      rclone
      ripgrep
      rsync
      screen
      traceroute
    ];
  };

  fonts.fontconfig.enable = false;

  i18n.supportedLocales = [ "en_US.UTF-8/UTF-8" ];

  networking = {
    firewall.enable = false;
    useDHCP = false;
    useNetworkd = true;
  };

  nix = {
    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };
    nrBuildUsers = 0;
    registry.nixpkgs.flake = inputs.nixpkgs;
    settings = {
      auto-allocate-uids = true;
      auto-optimise-store = true;
      experimental-features = [ "auto-allocate-uids" "cgroups" "flakes" "nix-command" ];
      nix-path = [ "nixpkgs=${inputs.nixpkgs}" ];
      use-cgroups = true;
    };
  };

  programs = {
    command-not-found.enable = false;
    fish = {
      enable = true;
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
      useBabelfish = true;
    };
    git.enable = true;
    htop.enable = true;
    iftop.enable = true;
    iotop.enable = true;
    mtr.enable = true;
    nano.syntaxHighlight = false;
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

  security.pki.caCertificateBlacklist = [
    "CFCA EV ROOT"
    "TrustCor ECA-1"
    "TrustCor RootCert CA-1"
    "TrustCor RootCert CA-2"
    "vTrus ECC Root CA"
    "vTrus Root CA"
  ];

  services = {
    journald.extraConfig = "SystemMaxUse=1G";
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
    age = {
      keyFile = "/var/lib/sops.key";
      sshKeyPaths = [ ];
    };
    gnupg.sshKeyPaths = [ ];
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
    network = {
      enable = true;
      networks.default = {
        DHCP = "yes";
        matchConfig.Type = "ether";
      };
    };
    services.traefik.serviceConfig.EnvironmentFile = config.sops.secrets.cloudflare_token.path;
  };

  time.timeZone = "Asia/Shanghai";

  users = {
    mutableUsers = false;
    users.root = {
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOnLRT5k4gZCKNaHbLg+jEsD5ZU1/V8Bh3WxiUIrB1Bu"
      ];
      passwordFile = config.sops.secrets.password_root.path;
      shell = pkgs.fish;
    };
  };
}
