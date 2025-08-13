{ pkgs, config, ... }: 
{
    # age.secrets.landaudiogo-ed25519 = {
    #     file = ../../../secrets/landaudiogo-ed25519.age;
    #     path = "${config.xdg.configHome}/.ssh/id_ed25519";
    # };
    # home.file."${config.xdg.configHome}/.ssh/id_ed25519.pub" = ;
    programs.ssh = {
        enable = true;
        matchBlocks = {
            federer = {
                user = "landaudiogo";
                hostname = "10.0.0.1";
                port = 22;
                identityFile = "~/.ssh/id_ed25519";
            };
            sinner = {
                user = "landaudiogo";
                hostname = "10.0.0.2";
                port = 22;
                identityFile = "~/.ssh/id_ed25519";
            };
            gijs1 = {
                user = "ubuntu";
                hostname = "18.197.157.103";
                port = 22;
                identityFile = "~/.ssh/id_ed25519";
            };
            gijs2 = {
                user = "ubuntu";
                hostname = "3.65.2.55";
                port = 22;
                identityFile = "~/.ssh/id_ed25519";
            };
            gijs3 = {
                user = "ubuntu";
                hostname = "18.193.68.182";
                port = 22;
                identityFile = "~/.ssh/id_ed25519";
            };
            joris = {
                user = "ubuntu";
                hostname = "3.68.216.145";
                port = 22;
                identityFile = "~/.ssh/id_ed25519";
            };
        };
    };
}
