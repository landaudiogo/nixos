{ ... }: 
{
    services.kubernetes = {
        roles = [ "node" ];
        easyCerts = true;
        masterAddress = "10.0.0.3";
        clusterCidr = "10.42.0.0/16";

        controllerManager.extraOpts = "--service-cluster-ip-range=10.43.0.0/16";
        apiserver.serviceClusterIpRange = "10.43.0.0/16";

        kubelet.extraOpts = "--fail-swap-on=false";
        kubelet.kubeconfig.server = "https://10.0.0.3:6443";
        kubelet.hostname = "sinner";
    };

    networking.firewall.allowedTCPPorts = [ 10250 ];
}
