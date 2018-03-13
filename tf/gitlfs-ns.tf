#provider "kubernetes" {
#  config_context_cluster = "gke_plasma-geode-127520_us-central1-b_git-lfs-prod"
#}

resource "kubernetes_namespace" "gitlfs" {
  metadata {
    name = "gitlfs"
  }
}
