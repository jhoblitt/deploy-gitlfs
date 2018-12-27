output "GITLFS_FQDN" {
  value = "${local.fqdn}"
}

output "GITLFS_IP" {
  value = "${module.nginx_ingress.ingress_ip}"
}

output "GOOGLE_CONTAINER_CLUSTER" {
  value = "${module.gke.id}"
}

output "ingress_ip" {
  value = "${module.nginx_ingress.ingress_ip}"
}
