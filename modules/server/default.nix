{ config, lib, pkgs, ... }:

{
  boot = {
    cleanTmpDir = true;
    kernel.sysctl = {
      # https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/net/ipv4/tcp_bbr.c#n55
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
    settings = {
      auto-allocate-uids = true;
      auto-optimise-store = true;
      experimental-features = [ "auto-allocate-uids" "cgroups" "flakes" "nix-command" ];
      use-cgroups = true;
    };
  };

  programs = {
    command-not-found.enable = false;
    fish = {
      enable = true;
      interactiveShellInit = "set -g fish_greeting";
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
    htop.enable = true;
    iftop.enable = true;
    mtr.enable = true;
    nano.syntaxHighlight = false;
    neovim = {
      defaultEditor = true;
      enable = true;
      viAlias = true;
      vimAlias = true;
      withRuby = false;
    };
    iotop.enable = true;
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
      kbdInteractiveAuthentication = false;
      passwordAuthentication = false;
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
