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
                    allowedIPs = [ "0.0.0.0/0" ];
                    endpoint = "77.171.239.251:51820";
                    persistentKeepalive = 25;
                }
            ];
        };
    };

}
