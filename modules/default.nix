{
  base = import ./base.nix;
  hath = import ./hath.nix;
  proxy = {
    client = import ./proxy/client.nix;
    server = import ./proxy/server.nix;
  };
  qbittorrent-nox = import ./qbittorrent-nox.nix;
  prometheus = {
    client = import ./prometheus/client.nix;
    server = import ./prometheus/server.nix;
  };
  resolved = {
    china = import ./resolved/china.nix;
    earth = import ./resolved/earth.nix;
  };
  server = import ./server;
  stress-ng = import ./stress-ng.nix;
  tor = import ./tor.nix;
  traefik = import ./traefik;
}
