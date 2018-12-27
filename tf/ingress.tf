resource "kubernetes_secret" "gitlfs_tls" {
  metadata {
    name      = "gitlfs-tls"
    namespace = "${kubernetes_namespace.gitlfs.metadata.0.name}"
  }

  data {
    tls.crt = "${local.tls_crt}"
    tls.key = "${local.tls_key}"
  }
}

resource "kubernetes_ingress" "gitlfs" {
  metadata {
    name      = "gitlfs"
    namespace = "${kubernetes_namespace.gitlfs.metadata.0.name}"

    annotations {
      "kubernetes.io/ingress.class"                 = "nginx"
      "nginx.ingress.kubernetes.io/affinity"        = "cookie"
      "nginx.ingress.kubernetes.io/proxy-body-size" = "0m"
      "nginx.ingress.kubernetes.io/ssl-redirect"    = "true"
      "nginx.ingress.kubernetes.io/rewrite-target"  = "/"

      "nginx.ingress.kubernetes.io/configuration-snippet" = <<INGRESS
proxy_set_header X-Forwarded-Proto https;
proxy_set_header X-Forwarded-Port 443;
proxy_set_header X-Forwarded-Path /;
INGRESS
    }
  }

  spec {
    tls {
      hosts       = ["${local.fqdn}"]
      secret_name = "${kubernetes_secret.gitlfs_tls.metadata.0.name}"
    }

    rule {
      host = "${local.fqdn}"

      http {
        path {
          path_regex = "/"

          backend {
            service_name = "${kubernetes_service.gitlfs.metadata.0.name}"
            service_port = "80"
          }
        }
      }
    }
  }

  depends_on = [
    "module.nginx_ingress",
  ]
}
