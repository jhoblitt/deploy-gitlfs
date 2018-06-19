provider "kubernetes" {
  version = "~> 1.1"

  host                   = "${google_container_cluster.gitlfs.endpoint}"
  client_certificate     = "${google_container_cluster.gitlfs.master_auth.0.client_certificate}"
  client_key             = "${google_container_cluster.gitlfs.master_auth.0.client_key}"
  cluster_ca_certificate = "${google_container_cluster.gitlfs.master_auth.0.cluster_ca_certificate}"
}
