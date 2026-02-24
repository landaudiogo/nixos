{ config, ...}:
{
    age.secrets.flatnotes.file = ../../../../secrets/flatnotes.age;
    virtualisation.oci-containers = {
        containers = {
            flatnotes = {
                image = "dullage/flatnotes@sha256:cfa8e12c818a977220677b72649a70db5fa49faf630b2e819e48ed37b1a9cba5";
                ports = [
                    "10.0.0.5:8080:8080"
                ];
                volumes = [ 
                    "/var/lib/flatnotes:/data"
                ];
                environmentFiles = [
                    config.age.secrets.flatnotes.path
                ];
            };
        };
    };
}
