let 
    djokovic = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGo8KvJT1coDqcfpSC+HdIthqVG0ZHJV7OH9lXTyKfPR djokovic";
    alcaraz = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL0IjHE9LCx6+5hCb0R2hP5SMBmgpqi/BMLk+7qkCDNr alcaraz";
    federer = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOi1C+kE5GSBa6MvnUEKwVrD0BrOVSNnrBpFccabm9Ou federer";
    landaudiogo = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP1COVqebDaCGC+bD3A7MgmFYMf5lMrHDUz+MBUn/oej landaudiogo";
    root = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJWjd0HS5ustz5grB4u8vtQcz1aINzESPu1ybrN+u6dy root";
in
{
    "djokovic-wireguard.age".publicKeys = [ djokovic ];
    "alcaraz-wireguard.age".publicKeys = [ alcaraz ];
    "federer-wireguard.age".publicKeys = [ federer ];
    "landaudiogo-ed25519.age".publicKeys = [ alcaraz federer ];
    "root-ed25519.age".publicKeys = [ alcaraz ];
}

