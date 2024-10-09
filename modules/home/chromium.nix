{ ... }:

{
  programs.chromium = {
    commandLineArgs = [
      "--enable-wayland-ime"
      "--ozone-platform-hint=auto"
      "--proxy-server=socks5://127.0.0.1:1080"
    ];
    enable = true;
  };
}
