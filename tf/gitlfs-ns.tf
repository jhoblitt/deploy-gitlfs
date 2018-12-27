resource "kubernetes_namespace" "gitlfs" {
  metadata {
    name = "gitlfs"
  }
}
