{ config, lib, ... }:

{
  services.openssh.passwordAuthentication = lib.mkForce true;

  sops.secrets."password/sftp".neededForUsers = true;

  users.users.sftp = {
    isNormalUser = true;
    passwordFile = config.sops.secrets."password/sftp".path;
  };
}
