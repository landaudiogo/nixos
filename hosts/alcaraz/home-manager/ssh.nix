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
            sinner = {
                user = "landaudiogo";
                hostname = "10.0.0.2";
                port = 22;
                identityFile = nixosConfig.age.secrets.landaudiogo-ed25519.path;
                identitiesOnly = true;
            };
            gijs1 = {
                user = "ubuntu";
                hostname = "3.76.124.233";
                port = 22;
                identityFile = "~/.ssh/gijs.pem";
            };
            gijs2 = {
                user = "ubuntu";
                hostname = "3.75.214.198";
                port = 22;
                identityFile = "~/.ssh/gijs.pem";
            };
            gijs3 = {
                user = "ubuntu";
                hostname = "3.71.49.28";
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
            kafka1 = {
                user = "ubuntu";
                hostname = "3.75.146.71";
                port = 22;
                identityFile = nixosConfig.age.secrets.gijs-rsa.path;
                identitiesOnly = true;
            };
            kafka2 = {
                user = "ubuntu";
                hostname = "63.179.176.200";
                port = 22;
                identityFile = nixosConfig.age.secrets.gijs-rsa.path;
                identitiesOnly = true;
            };
            kafka3 = {
                user = "ubuntu";
                hostname = "63.179.188.230";
                port = 22;
                identityFile = nixosConfig.age.secrets.gijs-rsa.path;
                identitiesOnly = true;
            };
            client1 = {
                user = "ubuntu";
                hostname = "52.214.46.228";
                port = 22;
                identityFile = nixosConfig.age.secrets.landaudiogo-ed25519.path;
                identitiesOnly = true;
            };
            client2 = {
                user = "ubuntu";
                hostname = "34.253.52.146";
                port = 22;
                identityFile = nixosConfig.age.secrets.landaudiogo-ed25519.path;
                identitiesOnly = true;
            };
            client34 = {
                user = "ubuntu";
                hostname = "34.241.90.236";
                port = 22;
                identityFile = nixosConfig.age.secrets.landaudiogo-ed25519.path;
                identitiesOnly = true;
            };
            group1 = {
                user = "ubuntu";
                hostname = "52.19.112.44";
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
            ip-172-31-31-167 = {
                user = "ubuntu";
                hostname = "3.75.176.4";
                port = 22;
                identityFile = nixosConfig.age.secrets.gijs-rsa.path;
                identitiesOnly = true;
            };
            ip-172-31-25-17 = {
                user = "ubuntu";
                hostname = "18.192.119.60";
                port = 22;
                identityFile = nixosConfig.age.secrets.gijs-rsa.path;
                identitiesOnly = true;
            };
            ip-172-31-27-25 = {
                user = "ubuntu";
                hostname = "18.197.102.90";
                port = 22;
                identityFile = nixosConfig.age.secrets.gijs-rsa.path;
                identitiesOnly = true;
            };
        };
    };
}
