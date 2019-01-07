resource "kubernetes_namespace" "gitlfs" {
  metadata {
    name = "${local.gitlfs_k8s_namespace}"
  }
}
