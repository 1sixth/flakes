{ config, lib, pkgs, ... }:

{
  boot = {
    kernel.sysctl = {
      # https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/net/ipv4/tcp_bbr.c#n55
      "net.core.default_qdisc" = "fq";
      "net.ipv4.tcp_congestion_control" = "bbr";
      # https://github.com/lucas-clemente/quic-go/wiki/UDP-Receive-Buffer-Size#non-bsd
      "net.core.rmem_max" = "2500000";
    };
    kernelPackages = pkgs.linuxPackages_latest;
    tmpOnTmpfs = true;
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
      gotop
      htop
      iftop
      iotop
      ldns
      mtr
      nmap
      rclone
      restic
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
    settings = {
      auto-optimise-store = true;
      experimental-features = [ "flakes" "nix-command" ];
    };
  };

  programs = {
    command-not-found.enable = false;
    fish = {
      enable = true;
      interactiveShellInit = ''
        set -g fish_greeting
        ${pkgs.starship}/bin/starship init fish | source
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
    neovim = {
      defaultEditor = true;
      enable = true;
      viAlias = true;
      vimAlias = true;
      withRuby = false;
    };
  };

  security.acme = {
    acceptTerms = true;
    certs."9875321.xyz" = {
      domain = "${config.networking.hostName}.9875321.xyz";
      extraDomainNames = [ "${config.networking.hostName}-cf.9875321.xyz" ];
    };
    defaults = {
      credentialsFile = config.sops.secrets.cloudflare_token.path;
      dnsProvider = "cloudflare";
      email = "acme@shinta.ro";
      reloadServices = [ "nginx.service" ];
    };
  };

  services = {
    journald.extraConfig = "SystemMaxUse=1G";
    nginx = {
      appendConfig = "worker_processes auto;";
      # Manage Nginx access logs via systemd-journald.
      appendHttpConfig = ''
        log_format custom '$remote_addr "$request_method $scheme://$host$request_uri $server_protocol" $status "$http_referer" "$http_user_agent"';
        access_log syslog:server=unix:/dev/log,nohostname custom;
      '';
      enable = true;
      package = pkgs.nginxMainline;
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
      virtualHosts = {
        "default" = {
          default = true;
          locations."/".return = "444";
          # Avoid leaking TLS certificates to IP scanners.
          rejectSSL = true;
        };
        "${config.networking.hostName}.9875321.xyz" = {
          forceSSL = true;
          locations = {
            "= /" = {
              extraConfig = "default_type text/plain;";
              return = "200 $remote_addr\\n";
            };
            "= /generate_204".return = "204";
          };
          serverAliases = [ "${config.networking.hostName}-cf.9875321.xyz" ];
          useACMEHost = "9875321.xyz";
        };
      };
    };
    openssh = {
      enable = true;
      hostKeys = [{
        path = "/etc/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }];
      kbdInteractiveAuthentication = false;
      passwordAuthentication = false;
    };
    vnstat.enable = true;
  };

  sops = {
    age.keyFile = "/var/lib/sops.key";
    secrets = {
      cloudflare_token = {
        owner = config.users.users.acme.name;
        inherit (config.users.users.acme) group;
        sopsFile = ./secrets.yaml;
      };
      "password/root" = {
        neededForUsers = true;
        sopsFile = ./secrets.yaml;
      };
    };
  };

  systemd.network = {
    enable = true;
    networks.default = {
      DHCP = "yes";
      matchConfig.Type = "ether";
    };
  };

  time.timeZone = "Asia/Shanghai";

  users = {
    mutableUsers = false;
    users = {
      nginx.extraGroups = [ "acme" ];
      root = {
        shell = pkgs.fish;
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOnLRT5k4gZCKNaHbLg+jEsD5ZU1/V8Bh3WxiUIrB1Bu"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC+AFJen4qsCeCiSqjMW2sWapGbtH3bk2Qsk//nTgGoV"
        ];
        passwordFile = config.sops.secrets."password/root".path;
      };
    };
  };
}
