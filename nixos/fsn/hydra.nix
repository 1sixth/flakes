{ config, pkgs, ... }:

{
  nix = {
    buildMachines = [
      {
        hostName = "fsn";
        maxJobs = 8;
        supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
        systems = [
          "i686-linux"
          "x86_64-linux"
        ];
      }
      {
        hostName = "tyo0";
        supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" "gccarch-armv8-a" ];
        systems = [
          "aarch64-linux"
        ];
      }
      {
        hostName = "tyo3";
        supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" "gccarch-armv8-a" ];
        systems = [
          "aarch64-linux"
        ];
      }
    ];
    distributedBuilds = true;
    settings.builders-use-substitutes = true;
  };

  programs.ssh = {
    extraConfig = ''
      Host fsn
        HostName fsn.9875321.xyz
        IdentityFile ${config.sops.secrets.ssh_private_key.path}
        User root
      Host tyo0
        HostName tyo0.9875321.xyz
        IdentityFile ${config.sops.secrets.ssh_private_key.path}
        User root
      Host tyo3
        HostName tyo3.9875321.xyz
        IdentityFile ${config.sops.secrets.ssh_private_key.path}
        User root
    '';
    knownHosts = {
      "fsn.9875321.xyz".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAss7ohT8nmKrKCtz2ca4MT98mDj/O0Ti+WxqCKI/+ba";
      "tyo0.9875321.xyz".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIILj2hY2QVnysE20yMSWzMyORXPs+LjbMi2GIzQXQuJO";
      "tyo3.9875321.xyz".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBQzz4TIaV597J0WfLYnmq9z4HcbddX/bBRXQctZVbhK";
    };
  };

  services = {
    hydra = {
      enable = true;
      extraConfig = ''
        binary_cache_secret_key_file = ${config.sops.secrets.secret-key-files.path}
        store_uri = auto?secret-key=${config.sops.secrets.secret-key-files.path}
        <githubstatus>
          jobs = personal:flakes:.*
        </githubstatus>
      '';
      hydraURL = "https://hydra.shinta.ro";
      listenHost = "127.0.0.1";
      notificationSender = "hydra@shinta.ro";
      useSubstitutes = true;
    };
    nginx.virtualHosts."hydra.shinta.ro" = {
      forceSSL = true;
      locations."/".proxyPass = "http://127.0.0.1:3000";
      useACMEHost = "shinta.ro";
    };
  };

  nix.settings.secret-key-files = config.sops.secrets.secret-key-files.path;

  sops.secrets = {
    secret-key-files = {
      mode = "0440";
      owner = config.users.users.hydra.name;
      inherit (config.users.users.hydra) group;
    };
    ssh_private_key = {
      mode = "0440";
      owner = config.users.users.hydra.name;
      inherit (config.users.users.hydra) group;
    };
  };
}
