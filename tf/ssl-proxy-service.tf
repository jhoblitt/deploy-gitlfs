resource "kubernetes_service" "ssl_proxy" {
  metadata {
    name      = "nginx-ssl-proxy"
    namespace = "gitlfs"

    labels {
      name = "nginx-ssl-proxy"
      role = "ssl-proxy"
      app  = "gitlfs"
    }
  } # metadata

  spec {
    selector {
      name = "nginx-ssl-proxy"
      role = "ssl-proxy"
      app  = "gitlfs"
    }

    type = "LoadBalancer"

    port {
      name = "http"
      port = 80

      #target_port = "ssl-proxy-http"
      target_port = 80
      protocol    = "TCP"
    }

    port {
      name = "https"
      port = 443

      #target_port = "ssl-proxy-https"
      target_port = 443
      protocol    = "TCP"
    }
  } # spec
}
