{
  prometheus = {
    client = import ./prometheus/client.nix;
    server = import ./prometheus/server.nix;
  };
  proxy = {
    client = import ./proxy/client;
    server = import ./proxy/server;
  };

  base = import ./base;
  laptop = import ./laptop;
  server = import ./server;
  traefik = import ./traefik;

  dns = import ./dns.nix;
  hath = import ./hath.nix;
  qbittorrent = import ./qbittorrent.nix;
  stress-ng = import ./stress-ng.nix;
  syncthing = import ./syncthing.nix;
}
