{ ... }:

{
  programs.chromium = {
    commandLineArgs = [
      "--ignore-gpu-blocklist"
      "--enable-gpu-rasterization"
      "--enable-zero-copy"
    ];
    enable = true;
    extensions = [{
      id = "dmmjlmbkigbgpnjfiimhlnbnmppjhpea";
      updateUrl = "https://raw.githubusercontent.com/ronggang/PT-Plugin-Plus/master/update/index.xml";
    }];
  };
}
