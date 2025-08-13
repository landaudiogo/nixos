let 
    djokovic = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGo8KvJT1coDqcfpSC+HdIthqVG0ZHJV7OH9lXTyKfPR djokovic";
    alcaraz = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL0IjHE9LCx6+5hCb0R2hP5SMBmgpqi/BMLk+7qkCDNr alcaraz";
    # landaudiogo = "";
in
{
    "djokovic-wireguard.age".publicKeys = [ djokovic ];
    "alcaraz-wireguard.age".publicKeys = [ alcaraz ];
}
