{ pkgs, ... }: {
  imports = [ ./marcopolo-github.nix ./common.nix ./darwin-common.nix ];
  home.stateVersion = "20.09";
  home.packages = with pkgs; [ nixpkgs-fmt nix-index nmap htop cacert hello ];

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
