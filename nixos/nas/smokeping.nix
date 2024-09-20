{ config, ... }:

{
  services = {
    nginx.virtualHosts.smokeping = {
      listen = [
        {
          addr = config.services.smokeping.host;
          port = 8081;
        }
      ];
    };
    smokeping = {
      databaseConfig = ''
        step     = 60
        pings    = 20
        # consfn mrhb steps total
        AVERAGE  0.5   1  1008
        AVERAGE  0.5  12  4320
            MIN  0.5  12  4320
            MAX  0.5  12  4320
        AVERAGE  0.5 144   720
            MAX  0.5 144   720
            MIN  0.5 144   720
      '';
      enable = true;
      host = "127.0.0.1";
      hostName = "${config.networking.hostName}.9875321.xyz";
      targetConfig = ''
        probe = FPing

        menu = Top
        title = Network Latency Grapher

        + AWS
        menu = AWS
        title = AWS

        ++ ap-northeast-1
        menu = Tokyo
        title = ap-northeast-1
        host = 3.112.0.0

        ++ ap-northeast-2
        menu = Seoul
        title = ap-northeast-2
        host = 3.34.0.0

        ++ ap-southeast-1
        menu = Singapore
        title = ap-southeast-1
        host = 3.0.0.9

        ++ eu-central-1
        menu = Frankfurt
        title = eu-central-1
        host = 3.64.0.0

        ++ eu-west-2
        menu = London
        title = eu-west-2
        host = 3.8.0.0

        ++ eu-west-3
        menu = Paris
        title = eu-west-3
        host = 13.36.0.0

        ++ us-west-2
        menu = Oregon
        title = us-west-2
        host = 18.236.0.0

        + BuyVM
        menu = BuyVM
        title = BuyVM

        ++ Las_Vegas
        menu = Las Vegas
        title = Las Vegas
        host = speedtest.lv.buyvm.net

        ++ Luxembourg
        menu = Luxembourg
        title = Luxembourg
        host = speedtest.lu.buyvm.net

        + Hetzner
        menu = Hetzner
        title = Hetzner

        ++ NBG1
        menu = nbg1
        title = nbg1
        host = nbg1-speed.hetzner.com

        ++ FSN1
        menu = fsn1
        title = fsn1
        host = fsn1-speed.hetzner.com

        ++ HEL
        menu = hel
        title = hel
        host = hel.icmp.hetzner.com

        ++ SIN
        menu = sin
        title = sin
        host = sin-speed.hetzner.com

        ++ HIL
        menu = hil
        title = hil
        host = hil-speed.hetzner.com

        ++ ASH
        menu = ash
        title = ash
        host = ash-speed.hetzner.com

        + LiteServer
        menu = LiteServer
        title = LiteServer

        ++ Dronten
        menu = Dronten
        title = drn
        host = lg-drn.liteserver.nl

        + Oracle_Cloud
        menu = Oracle Cloud
        title = Oracle Cloud

        ++ chuncheon
        menu = Chuncheon
        title = Chuncheon
        host = objectstorage.ap-chuncheon-1.oraclecloud.com

        ++ osaka
        menu = Osaka
        title = Osaka
        host = objectstorage.ap-osaka-1.oraclecloud.com

        ++ seoul
        menu = Seoul
        title = Seoul
        host = objectstorage.ap-seoul-1.oraclecloud.com

        ++ singapore-1
        menu = Singapore-1
        title = Singapore-1
        host = objectstorage.ap-singapore-1.oraclecloud.com

        ++ singapore-2
        menu = Singapore-2
        title = Singapore-2
        host = objectstorage.ap-singapore-2.oraclecloud.com

        ++ tokyo
        menu = Tokyo
        title = Tokyo
        host = objectstorage.ap-tokyo-1.oraclecloud.com

        ++ frankfurt
        menu = Frankfurt
        title = Frankfurt
        host = objectstorage.eu-frankfurt-1.oraclecloud.com

        ++ chicago
        menu = Chicago
        title = Chicago
        host = objectstorage.us-chicago-1.oraclecloud.com

        ++ phoenix
        menu = Phoenix
        title = Phoenix
        host = objectstorage.us-phoenix-1.oraclecloud.com

        ++ sanjose
        menu = San Jose
        title = San Jose
        host = objectstorage.us-sanjose-1.oraclecloud.com

        + RackNerd
        menu = RackNerd
        title = RackNerd

        ++ Los_Angeles
        menu = Los Angeles DC02
        title = Los Angeles DC02
        host = lg-lax02.racknerd.com

        ++ San_Jose
        menu = San Jose
        title = San Jose
        host = lg-sj.racknerd.com

        ++ Seattle
        menu = Seattle
        title = Seattle
        host = lg-sea.racknerd.com

        ++ Dallas
        menu = Dallas
        title = Dallas
        host = lg-dal.racknerd.com

        ++ Strasbourg
        menu = Strasbourg
        title = Strasbourg
        host = lg-fr.racknerd.com
      '';
    };
    traefik.dynamicConfigOptions.http = {
      routers.smokeping = {
        rule = "Host(`${config.networking.hostName}.9875321.xyz`) && PathPrefix(`/`)";
        service = "smokeping";
      };
      services.smokeping.loadBalancer.servers = [
        { url = "http://127.0.0.1:8081"; }
      ];
    };
  };

  users = {
    groups.${config.services.smokeping.user}.gid = 250;
    users.${config.services.smokeping.user}.uid = 250;
  };
}
