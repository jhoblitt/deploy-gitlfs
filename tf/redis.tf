# see https://github.com/kubernetes/helm/issues/2224

#resource "kubernetes_service_account" "helm" {
#  metadata {
#    name = "tiller"
#  }
#}

#resource "kubernetes_service_account" "helm" {
#  metadata {
#    name      = "tiller"
#    namespace = "kube-system"
#  }
#}

# :( no clusterrolebindings yet
# https://github.com/terraform-providers/terraform-provider-kubernetes/pull/73
#
# kubectl create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:tiller

provider "helm" {
  kubernetes {
    host                   = "${google_container_cluster.gitlfs.endpoint}"
    client_certificate     = "${base64decode(google_container_cluster.gitlfs.master_auth.0.client_certificate)}"
    client_key             = "${base64decode(google_container_cluster.gitlfs.master_auth.0.client_key)}"
    cluster_ca_certificate = "${base64decode(google_container_cluster.gitlfs.master_auth.0.cluster_ca_certificate)}"
  }
}

resource "helm_release" "redis" {
  name      = "redis"
  chart     = "stable/redis"
  namespace = "gitlfs"

  force_update  = true
  recreate_pods = true

  # "booleans" must be quoted strings instead of hci/json boolean values
  set {
    name  = "persistence.enabled"
    value = "false"
  }

  set {
    name  = "usePassword"
    value = "false"
  }

  #  depends_on = [ "kubernetes_service_account.helm" ]
}
