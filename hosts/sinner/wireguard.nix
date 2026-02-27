{ config, ... }:
let
    publicKeys = (import ../../modules/nixos/wireguard.nix).publicKeys;
in
{
    age.secrets.sinner-wireguard.file = ../../secrets/sinner-wireguard.age;

    networking.wg-quick.interfaces = {
        wg0 = {
            address = [ "10.0.0.2/24" ];
            privateKeyFile = config.age.secrets.sinner-wireguard.path;
          
            peers = [
                {
                    publicKey = publicKeys.federer;
                    allowedIPs = [ "0.0.0.0/0" ];
                    endpoint = "77.171.239.251:51820";
                    persistentKeepalive = 25;
                }
            ];
        };
    };
}
