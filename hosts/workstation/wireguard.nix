{ config, ... }:
let
    publicKeys = (import ../../modules/nixos/wireguard.nix).publicKeys;
in
{
    networking.firewall.interfaces.wg0.allowedTCPPorts = [ 22 ];
    age.secrets.workstation-wireguard.file = ../../secrets/workstation-wireguard.age;
    networking.wg-quick.interfaces = {
        wg0 = {
            address = [ "10.0.0.11/32" ];
            privateKeyFile = config.age.secrets.workstation-wireguard.path;
                
            peers = [
                {
                    # federer
                    publicKey = publicKeys.federer; 
                    allowedIPs = [ "10.0.0.0/24" ];
                    endpoint = "192.168.0.36:51820";
                    persistentKeepalive = 25;
                }
            ];
        };
    };

}
