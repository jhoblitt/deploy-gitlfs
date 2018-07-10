resource "kubernetes_secret" "ssl_proxy" {
  metadata {
    name      = "ssl-proxy-secret"
    namespace = "gitlfs"
  }

  data {
    proxycert = "${file("${path.module}/lsst-certs/lsst.codes/2018/lsst.codes_chain.pem")}"
    proxykey  = "${file("${path.module}/lsst-certs/lsst.codes/2018/lsst.codes.key")}"
    dhparam   = "${file("${path.module}/dhparam.pem")}"
  }
}
