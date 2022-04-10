{ config, ... }:

{
  sops.secrets.hath = { };

  virtualisation.oci-containers.containers."hath" = {
    autoStart = true;
    environmentFiles = [ config.sops.secrets.hath.path ];
    extraOptions = [ "--network=host" ];
    image = "docker.io/frosty5689/hath";
    volumes = [
      "/persistent/hath/cache:/hath/cache"
      "/persistent/hath/data:/hath/data"
      "/persistent/hath/download:/hath/download"
      "/persistent/hath/log:/hath/log"
      "/persistent/hath/tmp:/hath/tmp"
    ];
  };
}
