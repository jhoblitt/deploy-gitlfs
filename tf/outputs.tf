output "gitlfs_fqdn" {
  value = "${local.fqdn}"
}

output "gitlfs_ip" {
  value = "${module.nginx_ingress.ingress_ip}"
}

output "gitlfs_url" {
  value = "https://${local.fqdn}"
}

output "google_container_cluster" {
  value = "${module.gke.id}"
}

output "ingress_ip" {
  value = "${module.nginx_ingress.ingress_ip}"
}
