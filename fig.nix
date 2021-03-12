{ pkgs, ... }: {
  imports = [ ./marcopolo-github.nix (import ./common.nix { }) ./darwin-common.nix ];
  home.stateVersion = "20.09";
  home.packages = with pkgs; [ nixpkgs-fmt nix-index nmap htop cacert git-crypt ];

  programs.ssh = {
    enable = true;
    controlMaster = "auto";
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

      "arm" = {
        user = "root";
        hostname = "arm";
        proxyJump = "lazyssh";
        identityFile = "/Users/marcomunizaga/code/personal-cluster/secrets/rex-aws-key";
      };

      "archiver" = {
        user = "root";
        hostname = "archiver";
        proxyJump = "lazyssh";
        identityFile = "/Users/marcomunizaga/code/personal-cluster/secrets/rex-aws-key";
      };


      "lazyssh" = {
        hostname = "pi4.local";
        port = 7922;
        user = "jump";
        identityFile = "/Users/marcomunizaga/code/personal-cluster/secrets/lazyssh_client_key";
        identitiesOnly = true;
        extraOptions = {
          "PreferredAuthentications" = "publickey";
        };
      };
    };
  };

  programs.vscode.enable = true;
  programs.vscode.extensions = [
    (pkgs.callPackage (import ./vscode-nix/remote-ssh.nix) { })
  ];
}
