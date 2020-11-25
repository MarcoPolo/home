{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/release-20.09";

  inputs.home-manager = {
    url = "github:nix-community/home-manager";
    inputs.nixpkgs.follows = "/nixpkgs";
  };


  outputs = { self, nixpkgs, ... }@inputs: {

    # nix build --show-trace .#homeManagerConfigurations.fig.activationPackage
    # result/activate
    homeManagerConfigurations = {
      fig = inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages."x86_64-darwin";
        # pkgs = nixpkgs;
        configuration = ./fig.nix;
        system = "x86_64-darwin";
        homeDirectory = "/Users/marcomunizaga";
        username = "marcomunizaga";
      };
    };

  };
}
