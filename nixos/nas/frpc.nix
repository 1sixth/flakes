{ config, pkgs, ... }:

{
  systemd.services.frpc = {
    after = [ "network-online.target" ];
    description = "Frp Client Service";
    serviceConfig = {
      ExecStart = "${pkgs.frp}/bin/frpc -c ${config.sops.secrets."frpc.ini".path}";
      ExecReload = "${pkgs.frp}/bin/frpc reload -c ${config.sops.secrets."frpc.ini".path}";
      LimitNOFILE = 1048576;
      Restart = "on-failure";
      RestartSec = "5s";
      User = "frpc";
    };
    wantedBy = [ "multi-user.target" ];
  };

  sops.secrets."frpc.ini" = {
    owner = config.users.users.frpc.name;
    restartUnits = [ "frpc.service" ];
  };

  users = {
    groups.frpc = { };
    users.frpc = {
      isSystemUser = true;
      group = "frpc";
    };
  };
}
