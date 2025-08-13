{ pkgs, config, nixosConfig, ... }: 
{
    programs.ssh = {
        enable = true;
        matchBlocks = {
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
            gijs1 = {
                user = "ubuntu";
                hostname = "18.197.157.103";
                port = 22;
                identityFile = "~/.ssh/gijs.pem";
            };
            gijs2 = {
                user = "ubuntu";
                hostname = "3.65.2.55";
                port = 22;
                identityFile = "~/.ssh/gijs.pem";
            };
            gijs3 = {
                user = "ubuntu";
                hostname = "18.193.68.182";
                port = 22;
                identityFile = nixosConfig.age.secrets.landaudiogo-ed25519.path;
                identitiesOnly = true;
            };
            joris = {
                user = "ubuntu";
                hostname = "3.68.216.145";
                port = 22;
                identityFile = nixosConfig.age.secrets.landaudiogo-ed25519.path;
                identitiesOnly = true;
            };
        };
    };
}
