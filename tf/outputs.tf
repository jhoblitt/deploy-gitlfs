output "GITLFS_FQDN" {
  sensitive = false
  value     = "${data.template_file.fqdn.rendered}"
}

output "GITLFS_IP" {
  sensitive = false
  value     = "${kubernetes_service.ssl_proxy.load_balancer_ingress.0.ip}"
}

output "GOOGLE_CONTAINER_CLUSTER" {
  sensitive = false
  value     = "${google_container_cluster.gitlfs.id}"
}
