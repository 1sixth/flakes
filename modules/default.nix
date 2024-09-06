{
  dns = {
    china = import ./dns/china.nix;
    earth = import ./dns/earth.nix;
  };
  profiles = {
    base = import ./profiles/base;
    laptop = import ./profiles/laptop;
    server = import ./profiles/server;
  };
  prometheus = {
    client = import ./prometheus/client.nix;
    server = import ./prometheus/server.nix;
  };
  proxy = {
    client = import ./proxy/client.nix;
    server = import ./proxy/server.nix;
  };
  traefik = import ./traefik;

  hath = import ./hath.nix;
  qbittorrent-nox = import ./qbittorrent-nox.nix;
  stress-ng = import ./stress-ng.nix;
  syncthing = import ./syncthing.nix;
  tor = import ./tor.nix;
}
