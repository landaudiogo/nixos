{ ... }: 
{
    services.kubernetes = {
        roles = [ "master" ];
        masterAddress = "10.0.0.3";
        easyCerts = true;
        kubelet.extraOpts = "--fail-swap-on=false";
        clusterCidr = "10.42.0.0/16";
        controllerManager.extraOpts = "--service-cluster-ip-range=10.43.0.0/16";
        apiserver.serviceClusterIpRange = "10.43.0.0/16";
    };

    networking.firewall.allowedTCPPorts = [ 6443 ];
}
