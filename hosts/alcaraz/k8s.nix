{ lib, ... }: 
{
    services.kubernetes = {
        roles = [ "master" ];
        masterAddress = "10.0.0.3";
        easyCerts = true;
        clusterCidr = "10.42.0.0/16";
        controllerManager.extraOpts = "--service-cluster-ip-range=10.43.0.0/16";
        apiserver.serviceClusterIpRange = "10.43.0.0/16";
        kubelet.extraOpts = "--fail-swap-on=false";
        kubelet.taints = lib.mkForce {};
        pki.cfsslAPIExtraSANs = [ "alcaraz.ad.dlandau.nl" ];
    };

    networking.firewall.allowedTCPPorts = [ 6443 8888 ];
}
