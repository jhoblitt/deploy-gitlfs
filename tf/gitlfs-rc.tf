resource "kubernetes_replication_controller" "gitlfs" {
  metadata {
    namespace = "gitlfs"
    name      = "gitlfs"

    labels {
      name = "gitlfs"
      app  = "gitlfs"
    }
  }

  spec {
    replicas = 1

    selector {
      name = "gitlfs"
      app  = "gitlfs"
    }

    template {
      container {
        name              = "gitlfs"
        image             = "docker.io/lsstsqre/gitlfs-server:gbbed4bd"
        image_pull_policy = "Always"

        port {
          name           = "gitlfs"
          container_port = 80
        }

        env {
          name = "AWS_ACCESS_KEY_ID"

          value_from {
            secret_key_ref {
              name = "gitlfs"
              key  = "AWS_ACCESS_KEY_ID"
            }
          }
        }

        env {
          name = "AWS_SECRET_ACCESS_KEY"

          value_from {
            secret_key_ref {
              name = "gitlfs"
              key  = "AWS_SECRET_ACCESS_KEY"
            }
          }
        }

        env {
          name = "AWS_REGION"

          value_from {
            secret_key_ref {
              name = "gitlfs"
              key  = "AWS_REGION"
            }
          }
        }

        env {
          name = "S3_BUCKET"

          value_from {
            secret_key_ref {
              name = "gitlfs"
              key  = "S3_BUCKET"
            }
          }
        }

        env {
          name = "LFS_SERVER_URL"

          value_from {
            secret_key_ref {
              name = "gitlfs"
              key  = "LFS_SERVER_URL"
            }
          }
        }
      } # container
    } # template
  } # spec
}
