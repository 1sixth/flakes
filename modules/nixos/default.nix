{
  dns = {
    china = import ./dns/china.nix;
    earth = import ./dns/earth.nix;
  };

  prometheus = {
    client = import ./prometheus/client.nix;
    server = import ./prometheus/server.nix;
  };
  proxy = {
    client = import ./proxy/client.nix;
    server = import ./proxy/server.nix;
  };

  base = import ./base;
  laptop = import ./laptop;
  server = import ./server;
  traefik = import ./traefik;

  hath = import ./hath.nix;
  qbittorrent-nox = import ./qbittorrent-nox.nix;
  stress-ng = import ./stress-ng.nix;
  syncthing = import ./syncthing.nix;
  tor = import ./tor.nix;
}
