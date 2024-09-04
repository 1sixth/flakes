{
  base = import ./base;
  dns = {
    china = import ./dns/china.nix;
    earth = import ./dns/earth.nix;
  };
  hath = import ./hath.nix;
  laptop = import ./laptop.nix;
  prometheus = {
    client = import ./prometheus/client.nix;
    server = import ./prometheus/server.nix;
  };
  proxy = {
    client = import ./proxy/client.nix;
    server = import ./proxy/server.nix;
  };
  qbittorrent-nox = import ./qbittorrent-nox.nix;
  server = import ./server;
  stress-ng = import ./stress-ng.nix;
  syncthing = import ./syncthing.nix;
  tor = import ./tor.nix;
  traefik = import ./traefik;
}
