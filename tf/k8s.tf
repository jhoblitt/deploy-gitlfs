provider "kubernetes" {
  version = "~> 1.1"

  host                   = "${module.gke.host}"
  client_certificate     = "${base64decode(module.gke.client_certificate)}"
  client_key             = "${base64decode(module.gke.client_key)}"
  cluster_ca_certificate = "${base64decode(module.gke.cluster_ca_certificate)}"
}
