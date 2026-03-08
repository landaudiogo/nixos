{ pkgs, lib, config, ... }:
let
    cfg = config.services.pdnsctl.zones;
    mkPdnsctlZoneService = (zone: zoneConfig:
        {
            script = builtins.concatStringsSep "\n" (
                builtins.map 
                (record: 
                    assert lib.assertMsg (lib.hasSuffix zone record.recordName) 
                        "Record '${record.recordName}' must be part of zone '${zone}'";
                    ''${pkgs.pdnsctl}/bin/create-rrset ${record.recordName} ${record.IPv4Address}''
                ) 
                zoneConfig.records
            );

            environment = {
                ZONE = "${zone}";
            };
            serviceConfig = {
                EnvironmentFile = zoneConfig.envFile;
                PassEnvironment = [ 
                    "PDNS_API_KEY" 
                    "ZONE" 
                    "PDNS_SERVER" 
                ];
                Type = "oneshot";
                User = "root";
                RemainAfterExit = true;
            };

            wantedBy = ["multi-user.target"];
        }
    );
    recordOption = lib.types.submodule {
        options = {
            recordName = lib.mkOption {
                type = lib.types.str;
            }; 
            IPv4Address = lib.mkOption {
                type = lib.types.str;
            };
        };
    };
    zoneOption = lib.types.submodule {
        options = {
            envFile = lib.mkOption {
                type = lib.types.path;
            };

            records = lib.mkOption {
                type = lib.types.listOf recordOption;
            };
        };  
    };

in
{
    options = {
        services.pdnsctl.zones = lib.mkOption {
            type = lib.types.attrsOf zoneOption;
            default = {};
        };
    };    

    config = {
        systemd.services = builtins.foldl' 
            (acc: pdnsctlService: acc // pdnsctlService) 
            {} 
            (
                lib.mapAttrsToList 
                (zone: zoneConfig: { "pdnsctl-${zone}" = mkPdnsctlZoneService zone zoneConfig;}) 
                cfg
            );
    };
}
