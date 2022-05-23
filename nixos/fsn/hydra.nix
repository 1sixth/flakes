{ config, pkgs, ... }:

{
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
    traefik.dynamicConfigOptions.http = {
      routers.hydra = {
        rule = "Host(`hydra.shinta.ro`)";
        service = "hydra";
      };
      services.hydra.loadBalancer.servers = [{ url = "http://127.0.0.1:3000"; }];
    };
  };

  nix.settings.secret-key-files = config.sops.secrets.secret-key-files.path;

  sops.secrets = {
    hydra-notify = {
      mode = "0440";
      owner = config.users.users.hydra-queue-runner.name;
      inherit (config.users.users.hydra) group;
    };
    secret-key-files = {
      mode = "0440";
      owner = config.users.users.hydra.name;
      inherit (config.users.users.hydra) group;
    };
  };

  systemd.services = {
    hydra-notify.serviceConfig.EnvironmentFile = config.sops.secrets.hydra-notify.path;
    hydra-queue-runner.path = [ pkgs.msmtp ];
    hydra-server.path = [ pkgs.msmtp ];
  };
}
