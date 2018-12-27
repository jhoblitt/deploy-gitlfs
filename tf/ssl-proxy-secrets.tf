resource "kubernetes_secret" "ssl_proxy" {
  metadata {
    name      = "ssl-proxy-secret"
    namespace = "${kubernetes_namespace.gitlfs.metadata.0.name}"
  }

  data {
    proxycert = "${file("${path.module}/lsst-certs/lsst.codes/2018/lsst.codes_chain.pem")}"
    proxykey  = "${file("${path.module}/lsst-certs/lsst.codes/2018/lsst.codes.key")}"
    dhparam   = "${file("${path.module}/dhparam.pem")}"
  }
}
