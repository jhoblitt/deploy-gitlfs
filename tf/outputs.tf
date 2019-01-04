output "gitlfs_fqdn" {
  description = "FQDN of gitlfs service."
  value       = "${local.fqdn}"
}

output "gitlfs_ip" {
  description = "IP of gitlfs service."
  value       = "${module.nginx_ingress.ingress_ip}"
}

output "gitlfs_url" {
  description = "URL of gitlfs service."
  value       = "https://${local.fqdn}"
}

output "google_container_cluster" {
  description = "Name of gke cluster created for gitlfs service."
  value       = "${module.gke.id}"
}

output "ingress_ip" {
  description = "IP of nginx-ingress service."
  value       = "${module.nginx_ingress.ingress_ip}"
}
