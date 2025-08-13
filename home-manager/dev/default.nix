{lib, config, pkgs, nixosConfig, ...}:
let
    cfg = config.role.dev;
in 
{
    imports = [
        ./git.nix
        ./lvim.nix
        ./tmux.nix 
        ./direnv.nix
        ./zsh
        ./../gui/alacritty.nix
    ];

    options = {
        role.dev.enable = lib.mkEnableOption "Enable Module";
    };

    config = lib.mkIf cfg.enable {
        programs.zsh.enable = true;
        programs.git.enable = true;
        programs.lvim.enable = true;
        programs.tmux.enable = true;
        programs.alacritty.enable = lib.mkIf nixosConfig.services.xserver.enable true;
    };
}
