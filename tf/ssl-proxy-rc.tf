resource "kubernetes_replication_controller" "ssl_proxy" {
  metadata {
    namespace = "gitlfs"
    name      = "nginx-ssl-proxy"

    labels {
      name = "nginx-ssl-proxy"
      role = "ssl-proxy"
      app  = "gitlfs"
    }
  }

  spec {
    replicas = 1

    selector {
      name = "nginx-ssl-proxy"
      role = "ssl-proxy"
      app  = "gitlfs"
    }

    template {
      container {
        name  = "nginx-ssl-proxy"
        image = "docker.io/lsstsqre/nginx-ssl-proxy:latest"

        env {
          name  = "SERVICE_HOST_ENV_NAME"
          value = "GITLFS_SERVICE_HOST"
        }

        env {
          name  = "SERVICE_PORT_ENV_NAME"
          value = "GITLFS_SERVICE_PORT_HTTP"
        }

        env {
          name  = "ENABLE_SSL"
          value = "true"
        }

        env {
          name  = "ENABLE_BASIC_AUTH"
          value = "false"
        }

        port {
          name           = "ssl-proxy-http"
          container_port = 80
        }

        port {
          name           = "ssl-proxy-https"
          container_port = 443
        }

        volume_mount {
          name       = "secrets"
          mount_path = "/etc/secrets"
          read_only  = true
        }
      } # container

      volume {
        name = "secrets"

        secret {
          secret_name = "ssl-proxy-secret"
        }
      }
    } # template
  } # spec
}
