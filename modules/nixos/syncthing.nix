{ config, ... }:

{
  services = {
    syncthing = {
      enable = true;
      overrideDevices = false;
      overrideFolders = false;
      settings = {
        # https://docs.syncthing.net/users/faq.html#why-do-i-get-host-check-error-in-the-gui-api
        gui.insecureSkipHostcheck = true;
        options = {
          setLowPriority = false;
          urAccepted = -1;
        };
      };
    };
    traefik.dynamicConfigOptions.http = {
      middlewares = {
        syncthing-redirect.redirectregex = {
          regex = "^(.*)/syncthing$";
          replacement = "$1/syncthing/";
        };
        syncthing-strip.stripprefix.prefixes = [ "/syncthing" ];
      };
      routers.syncthing = {
        middlewares = [
          "syncthing-redirect"
          "syncthing-strip"
        ];
        rule = "Host(`${config.networking.hostName}.9875321.xyz`) && PathPrefix(`/syncthing`)";
        service = "syncthing";
      };
      services.syncthing.loadBalancer.servers = [
        { url = "http://${config.services.syncthing.guiAddress}"; }
      ];
    };
  };
}
