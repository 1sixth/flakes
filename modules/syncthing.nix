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
      routers.syncthing = {
        rule = "Host(`${config.networking.hostName}.9875321.xyz`)";
        service = "syncthing";
      };
      services.syncthing.loadBalancer.servers = [
        { url = "http://${config.services.syncthing.guiAddress}"; }
      ];
    };
  };
}
