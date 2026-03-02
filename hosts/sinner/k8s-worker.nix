{ config, ... }: 
{
    services.kubernetes = {
        roles = [ "node" ];
        masterAddress = "federer.ad.dlandau.nl";
        clusterCidr = "10.42.0.0/16";
        apiserver.serviceClusterIpRange = "10.43.0.0/16";

        easyCerts = false;
        caFile = "${config.services.kubernetes.secretsPath}/ca.pem";
        pki = {
            enable = true;
            genCfsslCACert = false;
            genCfsslAPIToken = false;
        };

        kubelet.extraOpts = "--fail-swap-on=false";
        kubelet.kubeconfig.server = "https://federer.ad.dlandau.nl:6443";
    };

    age.secrets.root-ca = {
        file = ../../secrets/root-ca.age;
        path = "${config.services.kubernetes.pki.caCertPathPrefix}.pem";
        owner = "root";
        symlink = false;
    };
    age.secrets.k8s-apitoken = {
        file = ../../secrets/k8s-apitoken.age;
        path = "${config.services.kubernetes.secretsPath}/apitoken.secret";
        owner = "root";
        symlink = false;
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
    networking.search = [ "ad.dlandau.nl" ];
}
