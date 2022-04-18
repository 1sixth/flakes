_:

{
  services.tor = {
    client.enable = true;
    enable = true;
    relay = { enable = true; role = "bridge"; };
    settings = {
      ExcludeNodes = "{cn},{hk},{mo}";
      ORPort = "auto";
      StrictNodes = 1;
    };
  };
}
