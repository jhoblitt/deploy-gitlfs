output "GITLFS_FQDN" {
  sensitive = false
  value     = "${local.fqdn}"
}

output "GITLFS_IP" {
  sensitive = false
  value     = "${kubernetes_service.ssl_proxy.load_balancer_ingress.0.ip}"
}

output "GOOGLE_CONTAINER_CLUSTER" {
  sensitive = false
  value     = "${module.gke.id}"
}
