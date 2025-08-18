{ pkgs, config, ... }:
{
  age.secrets.pdns-env.file = ../../../../secrets/pdns-env.age;

  virtualisation.docker.enable = true;
  virtualisation.oci-containers = {
    backend = "docker";
    containers = {
        pdns = {
            image = "powerdns/pdns-auth-45:4.5.1";
            user = "root";
            cmd = [
                "--local-address=0.0.0.0" 
                "--local-port=5300"
            ];
            environmentFiles = [ config.age.secrets.pdns-env.path ];
            ports = [
                "53:5300"
                "53:5300/udp"
                "10.0.0.1:8081:8081"
            ];
            volumes = [ "/var/lib/powerdns2:/var/lib/powerdns" ];
        };
    };
  };
  systemd.services.docker-pdns =
    let
        schema = ./schema.sql;
    in 
      {
        path = [ pkgs.sqlite ];
        preStart = ''
            volume="''$(echo ${builtins.elemAt config.virtualisation.oci-containers.containers.pdns.volumes 0} | cut -d ":" -f1)"
            if test -e $volume; then
                echo "volume exists"
            else
                echo "missing volume $volume"
                mkdir -p "$volume"
                sqlite3 -init ${schema} "$volume/pdns.sqlite3"
            fi
        '';
      };
}
