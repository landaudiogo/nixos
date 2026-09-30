{ pkgs, config, nixosConfig, ... }: 
{
    programs.ssh = {
        enable = true; matchBlocks = {
            djokovic = {
                user = "landaudiogo";
                hostname = "10.0.0.5";
                port = 22;
                identityFile = nixosConfig.age.secrets.landaudiogo-ed25519.path;
                identitiesOnly = true;
            };
            federer = {
                user = "landaudiogo";
                hostname = "10.0.0.1";
                port = 22;
                identityFile = nixosConfig.age.secrets.landaudiogo-ed25519.path;
                identitiesOnly = true;
            };
            sinner = {
                user = "landaudiogo";
                hostname = "10.0.0.2";
                port = 22;
                identityFile = nixosConfig.age.secrets.landaudiogo-ed25519.path;
                identitiesOnly = true;
            };
        };
    };
}
