resource "kubernetes_service" "gitlfs" {
  metadata {
    name      = "gitlfs"
    namespace = "${kubernetes_namespace.gitlfs.metadata.0.name}"

    labels {
      name = "gitlfs"
      app  = "gitlfs"
    }
  } # metadata

  spec {
    selector {
      name = "gitlfs"
      app  = "gitlfs"
    }

    #type = "LoadBalancer"

    port {
      name = "http"
      port = 80

      #target_port = "ssl-proxy-http"
      target_port = 80
      protocol    = "TCP"
    }
  } # spec
}
