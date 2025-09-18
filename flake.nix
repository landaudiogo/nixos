{
    inputs = {
        nixpkgs-2411.url = "github:NixOS/nixpkgs/nixos-24.11";
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
        nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
        home-manager = {
            url = "github:nix-community/home-manager/release-25.05";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        agenix = {
            url = "github:ryantm/agenix";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        cec-infrastructure = {
            url = "github:EC-labs/cec-infrastructure/a2cf43b";
        };
    };

    outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, agenix, cec-infrastructure, ... }@inputs:
        let
            system = "x86_64-linux";
            overlay-unstable = final: prev: {
                unstable = import nixpkgs-unstable {
                    inherit system;
                    config.allowUnfree = true;
                };
            };
        in rec {
            nixosConfigurations = {
                djokovic = nixpkgs.lib.nixosSystem {
                    specialArgs = { inherit inputs; };
                    modules = [
                        ({ config, pkgs, ... }: { nixpkgs.overlays = [ overlay-unstable ]; })
                        home-manager.nixosModules.default
                        agenix.nixosModules.default
                        ./modules/nixos
                        ./hosts/djokovic/configuration.nix
                    ];
                };

                alcaraz = nixpkgs.lib.nixosSystem {
                    specialArgs = { inherit inputs; };
                    modules = [
                        ({ config, pkgs, ... }: { nixpkgs.overlays = [ overlay-unstable ]; })
                        home-manager.nixosModules.default
                        agenix.nixosModules.default
                        ./modules/nixos
                        ./hosts/alcaraz/configuration.nix
                    ];
                };

                federer = nixpkgs.lib.nixosSystem {
                    specialArgs = { inherit inputs; };
                    modules = [
                        ({ config, pkgs, ... }: { nixpkgs.overlays = [ overlay-unstable ]; })
                        home-manager.nixosModules.default
                        agenix.nixosModules.default
                        ./modules/nixos
                        ./hosts/federer/configuration.nix
                    ];
                };
            };
        };
}
