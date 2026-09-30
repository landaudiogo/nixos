{ config, ... }:
let
    publicKeys = (import ../../modules/nixos/wireguard.nix).publicKeys;
in
{
    age.secrets.alcaraz-wireguard.file = ../../secrets/alcaraz-wireguard.age;
    networking.wg-quick.interfaces = {
        wg0 = {
            address = [ "10.0.0.3/32" ];
            privateKeyFile = config.age.secrets.alcaraz-wireguard.path;
                
            peers = [
                {
                    # federer
                    publicKey = publicKeys.federer; 
                    allowedIPs = [ "10.0.0.0/24" ];
                    endpoint = "83.87.96.61:51820";
                    persistentKeepalive = 25;
                }
            ];
        };
    };

}
