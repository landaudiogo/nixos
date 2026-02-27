sudo nixos-rebuild --flake .#federer --target-host root-federer switch
sudo nixos-rebuild --flake .#djokovic --target-host root-djokovic switch
sudo nixos-rebuild --flake .#sinner --target-host root-sinner switch
sudo nixos-rebuild switch --flake .#alcaraz

nix run github:ryantm/agenix -- -e <file>

nix build .#nixosConfigurations.federer.config.system.build.toplevel
