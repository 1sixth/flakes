{ config, pkgs, ... }:

{
  documentation.nixos.enable = false;

  environment = {
    persistence."/persistent/impermanence".files = [
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
    ];
    systemPackages = with pkgs; [
      eza
      nmap
      screen
    ];
  };

  fonts.fontconfig.enable = false;

  programs = {
    fish = {
      interactiveShellInit = "set -g fish_greeting";
      shellAliases = {
        l = "ll --all";
        ll = "ls --group --long --time-style=long-iso";
        ls = "eza --group-directories-first --no-quotes";
        tree = "ls --tree";

        sys = "systemctl";

        jou = "journalctl";
      };
    };
    git.enable = true;
    neovim = {
      configure.customRC = "set mouse=";
      defaultEditor = true;
      enable = true;
      viAlias = true;
      vimAlias = true;
      withRuby = false;
    };
  };

  security.sudo.enable = false;

  services = {
    openssh = {
      enable = true;
      hostKeys = [
        {
          path = "/etc/ssh/ssh_host_ed25519_key";
          type = "ed25519";
        }
      ];
      ports = [
        22
        2222
      ];
      settings = {
        KbdInteractiveAuthentication = false;
        PasswordAuthentication = false;
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
    services.traefik.serviceConfig.EnvironmentFile = [ config.sops.secrets.cloudflare_token.path ];
  };

  users.users.root = {
    hashedPasswordFile = config.sops.secrets.password_root.path;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAHOSqODpw3my6PkhWrAD/sulDNCiNjKqLjNOtFPMFwr" # Normal ssh-ed25519 Key
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIFo0aSRnBTZxloY4B3UBOtuRJVEKjs5qgjKerAB2sSr7AAAABHNzaDo=" # ed25519-sk Resident Key
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOnLRT5k4gZCKNaHbLg+jEsD5ZU1/V8Bh3WxiUIrB1Bu" # GPG Authencation Key (Backup)
    ];
  };
}
