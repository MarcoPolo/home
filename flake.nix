{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/release-20.09";

  inputs.home-manager = {
    url = "github:nix-community/home-manager";
    inputs.nixpkgs.follows = "/nixpkgs";
  };

  inputs.restic = {
    url = "github:marcopolo/restic-nix";
    inputs.nixpkgs.follows = "/nixpkgs";
  };

  outputs = { self, nixpkgs, restic, ... }@inputs: {
    # nix-shell -I nixpkgs=channel:nixos-20.09 --packages nixFlakes home-manager
    # nix build --experimental-features 'flakes nix-command' --show-trace .#homeManagerConfigurations.fig.activationPackage
    # result/activate
    # Or if you already have nixFlakes in nix-env.
    # nix build .#homeManagerConfigurations.fig.activationPackage && result/activate
    homeManagerConfigurations = {
      fig =
        let pkgs = import nixpkgs { system = "x86_64-darwin"; overlays = [ (self: super: { restic = restic.defaultPackage."x86_64-darwin"; }) ]; };
        in
        inputs.home-manager.lib.homeManagerConfiguration {
          # pkgs = import nixpkgs { system = "x86_64-darwin"; overlays = [ (self: super: { restic2 = restic.defaultPackage."x86_64-darwin"; }) ]; };
          pkgs = pkgs;
          # pkgs = nixpkgs;
          configuration = import ./fig.nix { inherit pkgs; };
          system = "x86_64-darwin";
          homeDirectory = "/Users/marcomunizaga";
          username = "marcomunizaga";
        };
      st-marco1 = inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages."x86_64-darwin";
        configuration = ./marco-st.nix;
        system = "x86_64-darwin";
        homeDirectory = "/Users/marco";
        username = "marco";
      };
    };

  };
}
