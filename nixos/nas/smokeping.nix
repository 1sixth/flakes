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
      probeConfig = ''
        + FPing
        binary = ${config.security.wrapperDir}/fping
        protocol = 4
      '';
      targetConfig = ''
        probe = FPing

        menu = Top
        title = Network Latency Grapher

        + Cloudflare
        menu = Cloudflare
        title = Cloudflare

        ++ Vault
        menu = Vault
        title = Vault
        host = vault.shinta.ro

        ++ Cloudflare
        menu = Cloudflare
        title = Cloudflare
        host = cloudflare.com

        + Domestic
        menu = Domestic
        title = Domestic

        ++ 119_29_29_29
        menu = 119.29.29.29
        title = 119.29.29.29
        host = 119.29.29.29

        ++ 223_5_5_5
        menu = 223.5.5.5
        title = 223.5.5.5
        host = 223.5.5.5

        ++ 223_6_6_6
        menu = 223.6.6.6
        title = 223.6.6.6
        host = 223.6.6.6

        ++ Alibaba_Cloud
        menu = Alibaba Cloud
        title = Alibaba Cloud
        host = aliyun.com

        ++ Baidu
        menu = Baidu
        title = Baidu
        host = baidu.com

        ++ Tencent_Cloud
        menu = Tencent Cloud
        title = Tencent Cloud
        host = cloud.tencent.com

        + Hosts
        menu = Hosts
        title = Hosts

        ++ lax0
        menu = lax0
        title = lax0
        host = lax0.9875321.xyz

        ++ nrt0
        menu = nrt0
        title = nrt0
        host = nrt0.9875321.xyz

        ++ nrt1
        menu = nrt1
        title = nrt1
        host = nrt1.9875321.xyz

        ++ nrt2
        menu = nrt2
        title = nrt2
        host = nrt2.9875321.xyz

        ++ sxb0
        menu = sxb0
        title = sxb0
        host = sxb0.9875321.xyz

        + Providers
        menu = Providers
        title = Providers

        ++ BandwagonHost
        menu = BandwagonHost
        title = BandwagonHost

        +++ Osaka
        menu = Osaka
        title = Osaka
        host = jpos.52bwg.com

        +++ Hong_Kong
        menu = Hong Kong
        title = Hong Kong
        host = hk85.52bwg.com

        +++ Amsterdam
        menu = Amsterdam
        title = Amsterdam
        host = eunl9.52bwg.com

        +++ DC6
        menu = DC6
        title = DC6
        host = dc6.52bwg.com

        +++ DC9
        menu = DC9
        title = DC9
        host = dc9.52bwg.com

        ++ ClawCloud
        menu = ClawCloud
        title = ClawCloud

        +++ Hong_Kong
        menu = Hong Kong
        title = Hong Kong
        host = lg.cn-hongkong.claw.cloud

        +++ Singapore
        menu = Singapore
        title = Singapore
        host = lg.ap-southeast-1.claw.cloud

        +++ Tokyo
        menu = Tokyo
        title = Tokyo
        host = lg.ap-northeast-1.claw.cloud

        +++ Virginia
        menu = Virginia
        title = Virginia
        host = lg.us-east-1.claw.cloud

        +++ Silicon_Valley
        menu = Silicon Valley
        title = Silicon Valley
        host = lg.us-west-1.claw.cloud

        +++ Frankfurt
        menu = Frankfurt
        title = Frankfurt
        host = lg.eu-central-1.claw.cloud

        ++ Hetzner
        menu = Hetzner
        title = Hetzner

        +++ NBG1
        menu = nbg1
        title = nbg1
        host = nbg1-speed.hetzner.com

        +++ FSN1
        menu = fsn1
        title = fsn1
        host = fsn1-speed.hetzner.com

        +++ HEL1
        menu = hel1
        title = hel1
        host = hel1-speed.hetzner.com

        +++ HIL
        menu = hil
        title = hil
        host = hil-speed.hetzner.com

        +++ ASH
        menu = ash
        title = ash
        host = ash-speed.hetzner.com

        +++ SIN
        menu = sin
        title = sin
        host = sin-speed.hetzner.com

        ++ LiteServer
        menu = LiteServer
        title = LiteServer
        host = lg-drn.liteserver.nl

        ++ RackNerd
        menu = RackNerd
        title = RackNerd

        +++ Los_Angeles
        menu = Los Angeles
        title = Los Angeles
        host = lg-lax02.racknerd.com

        +++ San_Jose
        menu = San Jose
        title = San Jose
        host = lg-sj.racknerd.com

        +++ Seattle
        menu = Seattle
        title = Seattle
        host = lg-sea.racknerd.com

        +++ Dallas
        menu = Dallas
        title = Dallas
        host = lg-dal.racknerd.com

        +++ Chicago
        menu = Chicago
        title = Chicago
        host = lg-chi.racknerd.com

        +++ New_York
        menu = New York
        title = New York
        host = lg-ny.racknerd.com

        +++ Ashburn
        menu = Ashburn
        title = Ashburn
        host = lg-ash.racknerd.com

        +++ Atlanta
        menu = Atlanta
        title = Atlanta
        host = lg-atl.racknerd.com

        +++ Strasbourg
        menu = Strasbourg
        title = Strasbourg
        host = lg-fr.racknerd.com

        +++ Amsterdam
        menu = Amsterdam
        title = Amsterdam
        host = lg-ams.racknerd.com

        +++ Dublin
        menu = Dublin
        title = Dublin
        host = lg-dub.racknerd.com

        ++ V_PS
        menu = V.PS
        title = V.PS

        +++ Frankfurt
        menu = Frankfurt
        title = Frankfurt
        host = fra.lg.v.ps

        ++ San_Jose
        menu = San Jose
        title = San Jose
        host = sjc.lg.v.ps

        +++ Seattle
        menu = Seattle
        title = Seattle
        host = sea.lg.v.ps

        +++ Osaka
        menu = Osaka
        title = Osaka
        host = kix.lg.v.ps

        +++ Tokyo
        menu = Tokyo
        title = Tokyo
        host = nrt.lg.v.ps
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
