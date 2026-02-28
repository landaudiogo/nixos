{ ... }: 
{
    services.kubernetes = {
        roles = [ "node" ];
        easyCerts = true;
        masterAddress = "alcaraz.ad.dlandau.nl";
        clusterCidr = "10.42.0.0/16";
        apiserver.serviceClusterIpRange = "10.43.0.0/16";

        kubelet.extraOpts = "--fail-swap-on=false";
        kubelet.kubeconfig.server = "https://alcaraz.ad.dlandau.nl:6443";
    };

    # For some reason, there is an issue when the SANs have colon's in their 
    # names, e.g., system:node:alcaraz. This led to requests to sign a 
    # certificates without the extra SANs. However, on re-inspection, certmgr 
    # would identify this mismatch and ask to sign another certificate, again
    # without the SAN. Ultimately, the repetition of this cycle caused kubelet
    # and the kube-apiserver to restart, and specified on the certmgr's 
    # configuration file.
    services.certmgr.specs.kubeProxyClient.request.hosts = [];
    services.certmgr.specs.kubeletClient.request.hosts = [];

    networking.firewall.allowedTCPPorts = [ 10250 ];
}
