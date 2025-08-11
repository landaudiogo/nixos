{
    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
        nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = { self, nixpkgs, nixpkgs-unstable, home-manager }@inputs:
        let
            system = "x86_64-linux";
            overlay-unstable = final: prev: {
                unstable = import nixpkgs-unstable {
                    inherit system;
                    config.allowUnfree = true;
                };
            };
        in rec {
            nixosConfigurations.djokovic = nixpkgs.lib.nixosSystem {
                modules = [
                    ({ config, pkgs, ... }: { nixpkgs.overlays = [ overlay-unstable ]; })
                    home-manager.nixosModules.default
                    ./configuration.nix
                ];
            };
        };
}
