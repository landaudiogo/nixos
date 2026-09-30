{ pkgs, config, nixosConfig, ... }: 
{
    programs.ssh = {
        enable = true;
        matchBlocks = {
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
            anon-git = {
                user = "git";
                hostname = "github.com";
                identityFile = "~/.ssh/yyuhj46l4y0s7mn";
                identitiesOnly = true;
            };
            client69 = {
                user = "ubuntu";
                hostname = "63.34.236.235";
                port = 22;
                identityFile = nixosConfig.age.secrets.landaudiogo-ed25519.path;
                identitiesOnly = true;
            };
            client70 = {
                user = "ubuntu";
                hostname = "63.34.238.111";
                port = 22;
                identityFile = nixosConfig.age.secrets.landaudiogo-ed25519.path;
                identitiesOnly = true;
            };
        };
    };
}
