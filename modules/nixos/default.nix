{
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

  dns = import ./dns.nix;
  hath = import ./hath.nix;
  qbittorrent-nox = import ./qbittorrent-nox.nix;
  stress-ng = import ./stress-ng.nix;
  syncthing = import ./syncthing.nix;
}
