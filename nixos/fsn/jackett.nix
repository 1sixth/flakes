{ config, ... }:

{
  services = {
    jackett.enable = true;
    nginx.virtualHosts."${config.networking.hostName}.9875321.xyz".locations."/jackett".proxyPass = "http://127.0.0.1:9117";
  };
}
