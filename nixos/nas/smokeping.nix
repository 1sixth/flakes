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

        + ClawCloud
        menu = ClawCloud
        title = ClawCloud

        ++ Hong_Kong
        menu = Hong Kong
        title = Hong Kong
        host = lg.cn-hongkong.claw.cloud

        ++ Tokyo
        menu = Tokyo
        title = Tokyo
        host = lg.ap-northeast-1.claw.cloud

        ++ Singapore
        menu = Singapore
        title = Singapore
        host = lg.ap-southeast-1.claw.cloud

        + GreenCloud
        menu = GreenCloud
        title = GreenCloud

        ++ Tokyo_SoftBank
        menu = Tokyo (SoftBank)
        title = Tokyo (SoftBank)
        host = 103.201.131.131

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
