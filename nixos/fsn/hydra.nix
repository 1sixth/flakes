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
      services.hydra.loadBalancer.servers = [{ url = "http://${config.services.hydra.listenHost}:${builtins.toString config.services.hydra.port}"; }];
    };
  };

  nix.settings = {
    allowed-uris = "http:// https://";
    secret-key-files = config.sops.secrets.secret-key-files.path;
  };

  sops.secrets.secret-key-files = {
    mode = "0440";
    owner = config.users.users.hydra.name;
    inherit (config.users.users.hydra) group;
  };
}
