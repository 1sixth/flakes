{ config, pkgs, ... }:

{
  # https://github.com/qbittorrent/qBittorrent/wiki/Traefik-Reverse-Proxy-for-Web-UI
  services.traefik.dynamicConfigOptions.http = {
    middlewares = {
      qb-redirect.redirectregex = {
        regex = "^(.*)/qbittorrent$";
        replacement = "$1/qbittorrent/";
      };
      qb-strip.stripprefix.prefixes = [ "/qbittorrent" ];
    };
    routers.qbittorrent = {
      middlewares = [
        "qb-redirect"
        "qb-strip"
      ];
      rule = "Host(`${config.networking.hostName}.9875321.xyz`) && PathPrefix(`/qbittorrent`)";
      service = "qbittorrent";
    };
    services.qbittorrent.loadBalancer.servers = [ { url = "http://127.0.0.1:8080"; } ];
  };

  # https://github.com/qbittorrent/qBittorrent/blob/615b76f78c8ab92ad57bed42fc4266950c9f0251/dist/unix/systemd/qbittorrent-nox%40.service.in
  systemd.services.qbittorrent-nox = {
    after = [
      "local-fs.target"
      "network-online.target"
      "nss-lookup.target"
    ];
    description = "qBittorrent-nox service";
    documentation = [ "man:qbittorrent-nox(1)" ];
    serviceConfig = {
      PrivateTmp = false;
      User = "qbittorrent";
      # https://github.com/qbittorrent/qBittorrent/wiki/How-to-use-portable-mode
      ExecStart = "${pkgs.qbittorrent-nox}/bin/qbittorrent-nox --profile=/var/lib/qbittorrent-nox --relative-fastresume";
      TimeoutStopSec = 1800;
      StateDirectory = "qbittorrent-nox";
    };
    wantedBy = [ "multi-user.target" ];
    wants = [ "network-online.target" ];
  };

  users = {
    groups.qbittorrent.gid = 1000;
    users.qbittorrent = {
      group = "qbittorrent";
      isSystemUser = true;
      uid = 1000;
    };
  };
}
