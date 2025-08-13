{ config, ... }:
let
    publicKeys = (import ../../modules/nixos/wireguard.nix).publicKeys;
in
{
    age.secrets.djokovic-wireguard.file = ../../secrets/djokovic-wireguard.age;
    networking.wg-quick.interfaces = {
        wg0 = {
            address = [ "10.0.0.5/32" ];
            privateKeyFile = config.age.secrets.djokovic-wireguard.path;
                
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
