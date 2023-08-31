{ config, pkgs, ... }:

{
  sops.secrets.hath = {
    owner = config.users.users.hath.name;
    inherit (config.users.users.hath) group;
    path = "/var/lib/hath/data/client_login";
    restartUnits = [ "hath.service" ];
  };

  # https://aur.archlinux.org/cgit/aur.git/tree/hath.service?h=hath&id=dff03029064eb52d8c36073806b7eab5e3d75003
  systemd.services.hath = {
    description = "Hentai@Home service";
    after = [ "network.target" ];
    wants = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      User = "hath";
      StateDirectory = "hath";
      WorkingDirectory = "/var/lib/hath";
      ExecStart = "${pkgs.HentaiAtHome}/bin/HentaiAtHome";
      SuccessExitStatus = 143;
      TimeoutStopSec = 10;
      Restart = "always";
      RestartSec = 5;
    };
  };

  users = {
    groups.hath = { };
    users.hath = {
      group = "hath";
      isSystemUser = true;
    };
  };
}
