let 
    djokovic = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGo8KvJT1coDqcfpSC+HdIthqVG0ZHJV7OH9lXTyKfPR djokovic";
    alcaraz = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL0IjHE9LCx6+5hCb0R2hP5SMBmgpqi/BMLk+7qkCDNr alcaraz";
    federer = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOi1C+kE5GSBa6MvnUEKwVrD0BrOVSNnrBpFccabm9Ou federer";
    landaudiogo = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP1COVqebDaCGC+bD3A7MgmFYMf5lMrHDUz+MBUn/oej landaudiogo";
    nadal = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ5VXFxQDCqH4tvEIb0q+b5FaMvtecUxPaHb6mWYqc3N nadal";
    root = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJWjd0HS5ustz5grB4u8vtQcz1aINzESPu1ybrN+u6dy root";
in
{
    "djokovic-wireguard.age".publicKeys = [ djokovic ];
    "alcaraz-wireguard.age".publicKeys = [ alcaraz ];
    "federer-wireguard.age".publicKeys = [ federer ];
    "nadal-wireguard.age".publicKeys = [ nadal ];
    "landaudiogo-ed25519.age".publicKeys = [ alcaraz federer ];
    "gijs-rsa.age".publicKeys = [ alcaraz landaudiogo ];
    "root-ed25519.age".publicKeys = [ alcaraz ];
    "pdns-api-key.age".publicKeys = [ federer landaudiogo ];
    "pdns-env.age".publicKeys = [ federer landaudiogo ];
    "lego-pdns.age".publicKeys = [ federer landaudiogo ];
    "flatnotes.age".publicKeys = [ djokovic landaudiogo ];
    "paperless-env.age".publicKeys = [ djokovic landaudiogo ];
    "diogo-Iphone-wireguard.age".publicKeys = [ landaudiogo ];
    "diogo-Ipad-wireguard.age".publicKeys = [ landaudiogo ];
    "ana-Ipad-wireguard.age".publicKeys = [ landaudiogo ];
    "ana-Iphone-wireguard.age".publicKeys = [ landaudiogo ];
    "ADTV-wireguard.age".publicKeys = [ landaudiogo ];
    "gluetun-env.age".publicKeys = [ djokovic landaudiogo ];
    "cec-creds-env.age".publicKeys = [ federer landaudiogo ];

}
