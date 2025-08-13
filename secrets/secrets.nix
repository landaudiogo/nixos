let 
    djokovic = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGo8KvJT1coDqcfpSC+HdIthqVG0ZHJV7OH9lXTyKfPR djokovic";
    # landaudiogo = "";
in
{
    "djokovic-wireguard.age".publicKeys = [ djokovic ];
}
