{ ... }: {
  imports = [ ./marcpolo-github.nix ./common.nix ];
  programs.ssh = {
    enable = true;

    matchBlocks = {
      rusty = { hostname = "rusty.marcopolo.io"; };
      "pi4" = {
        hostname = "pi4.local";
        user = "marco";
      };
      "local-nixos" = {
        hostname = "10.211.55.7";
        user = "marco";
      };
      "rex" = {
        # hostname = "rex.local";
        hostname = "192.168.125.2";
        user = "marco";
      };
      "dex" = {
        hostname = "dex.local";
        user = "marco";
      };
    };
  };
}
