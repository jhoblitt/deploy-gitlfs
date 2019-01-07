resource "helm_release" "redis" {
  name      = "redis"
  chart     = "stable/redis"
  namespace = "${kubernetes_namespace.gitlfs.metadata.0.name}"
  version   = "5.1.3"

  keyring       = ""
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

  depends_on = [
    "module.tiller",
  ]
}
