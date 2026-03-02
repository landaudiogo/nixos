{ lib, config, ... }: 
{
    services.kubernetes = {
        roles = [ "master" ];
        masterAddress = "10.0.0.3";

        # Self-Signed Certs
        easyCerts = false;
        caFile = "${config.services.kubernetes.secretsPath}/ca.pem";
        pki = {
            enable = true;
            genCfsslCACert = false;
            genCfsslAPIToken = false;
            cfsslAPIExtraSANs = [ "alcaraz.ad.dlandau.nl" ];
        };

        clusterCidr = "10.42.0.0/16";
        controllerManager.extraOpts = "--service-cluster-ip-range=10.43.0.0/16";
        apiserver.serviceClusterIpRange = "10.43.0.0/16";
        apiserver.extraSANs = [ "alcaraz.ad.dlandau.nl" ];

        kubelet.extraOpts = "--fail-swap-on=false";
    };

    age.secrets.root-ca = {
        file = ../../secrets/root-ca.age;
        path = "${config.services.kubernetes.pki.caCertPathPrefix}.pem";
        owner = "cfssl";
        symlink = false;
    };
    age.secrets.root-ca-key = {
        file = ../../secrets/root-ca-key.age;
        path = "${config.services.kubernetes.pki.caCertPathPrefix}-key.pem";
        owner = "cfssl";
        symlink = false;
    };
    age.secrets.k8s-apitoken = {
        file = ../../secrets/k8s-apitoken.age;
        path = "${config.services.cfssl.dataDir}/apitoken.secret";
        owner = "cfssl";
        symlink = false;
    };


    # For some reason, there is an issue when the SANs have colon's in their 
    # names, e.g., system:node:alcaraz. This led to requests to sign a 
    # certificates without the extra SANs. However, on re-inspection, certmgr 
    # would identify this mismatch and ask to sign another certificate, again
    # without the SAN. Ultimately, the repetition of this cycle caused kubelet
    # and the kube-apiserver to restart, and specified on the certmgr's 
    # configuration file.
    services.certmgr.specs.apiserverKubeletClient.request.hosts = [];
    services.certmgr.specs.serviceAccount.request.hosts = [];
    services.certmgr.specs.controllerManagerClient.request.hosts = [];
    services.certmgr.specs.kubeProxyClient.request.hosts = [];
    services.certmgr.specs.schedulerClient.request.hosts = [];
    services.certmgr.specs.kubeletClient.request.hosts = [];
    services.certmgr.specs.addonManager.request.hosts = [];

    networking.firewall.allowedTCPPorts = [ 6443 8888 ];
    networking.search = [ "ad.dlandau.nl" ];
}
