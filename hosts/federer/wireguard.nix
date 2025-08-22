{ pkgs, config, ... }:
let 
    publicKeys = (import ../../modules/nixos/wireguard.nix).publicKeys;
in
{
    age.secrets.federer-wireguard.file = ../../secrets/federer-wireguard.age;
    networking.nat.enable = true;
    networking.nat.externalInterface = "eth0";
    networking.nat.internalInterfaces = [ "wg0" ];
    networking.firewall.allowedUDPPorts = [ 51820 ];
    networking.firewall.interfaces.wg0.allowedTCPPorts = [ 22 12470 ];
    networking.wireguard.enable = true;
    networking.wireguard.interfaces = {
        wg0 = {
            ips = [ "10.0.0.1/24" ];
            listenPort = 51820;

            postSetup = ''
                ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.0.0.0/24 -o enp3s0 -j MASQUERADE
                ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.0.0.0/24 -o wlp2s0 -j MASQUERADE
            '';

            postShutdown = ''
                ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.0.0.0/24 -o enp3s0 -j MASQUERADE
                ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.0.0.0/24 -o wlp2s0 -j MASQUERADE
            '';

            privateKeyFile = config.age.secrets.federer-wireguard.path;

            peers = [
                {
                    # sinner
                    publicKey = "o1ewLdYWN5mPGe6yOUzhJhfZTZsmBnZak4C9Y/tIBg8=";
                    allowedIPs = [ "10.0.0.2/32" ];
                }
                {
                    # alcaraz
                    publicKey = publicKeys.alcaraz;
                    allowedIPs = [ "10.0.0.3/32" ];
                }
                {
                    # Dominguitos Ipad
                    publicKey = "xfhYdRgHFmNLxpsSBuB2vxeX/33L64mN6q7p58f2Rh4=";
                    allowedIPs = [ "10.0.0.4/32" ];
                }
                { 
                    # djokovic
                    publicKey = publicKeys.djokovic;
                    allowedIPs = [ "10.0.0.5/32" ];
                }
                { 
                    # landau Iphone
                    publicKey = publicKeys.diogoIphone;
                    allowedIPs = [ "10.0.0.6/32" ];
                }
                { 
                    # ADTV
                    publicKey = publicKeys.ADTV;
                    allowedIPs = [ "10.0.0.7/32" ];
                }
            ];
        };
    };
}
