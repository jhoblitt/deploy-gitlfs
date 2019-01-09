provider "template" {
  version = "~> 1.0"
}

provider "google" {
  version = "~> 1.20"
}

provider "null" {
  version = "~> 1.0"
}

module "gke" {
  source = "git::https://github.com/lsst-sqre/terraform-gke-std.git//?ref=master"

  name               = "${local.gke_cluster_name}"
  google_project     = "${var.google_project}"
  gke_version        = "latest"
  initial_node_count = 3
  machine_type       = "n1-standard-1"
}

resource "null_resource" "gcloud_container_clusters_credentials" {
  triggers = {
    google_containre_cluster_endpoint = "${module.gke.id}"
  }

  provisioner "local-exec" {
    command = "gcloud container clusters get-credentials ${local.gke_cluster_name}"
  }

  depends_on = [
    "module.gke",
  ]
}

provider "kubernetes" {
  version = "1.3.0-custom"

  load_config_file = true

  host                   = "${module.gke.host}"
  cluster_ca_certificate = "${base64decode(module.gke.cluster_ca_certificate)}"
}

provider "aws" {
  version = "~> 1.54"
  region  = "${var.aws_primary_region}"
}

provider "aws" {
  version = "~> 1.54"
  region  = "${var.aws_primary_region}"
  alias   = "primary"
}

provider "aws" {
  # providers are initialized early and can't use a local var to DRY version
  version = "~> 1.54"
  region  = "${var.aws_backup_region}"
  alias   = "backup"
}

module "tiller" {
  source = "git::https://github.com/lsst-sqre/terraform-tinfoil-tiller.git//?ref=sl1pm4t-1.3.0"

  namespace       = "kube-system"
  service_account = "tiller"
  tiller_image    = "gcr.io/kubernetes-helm/tiller:v2.11.0"
}

provider "helm" {
  version = "~> 0.7.0"

  service_account = "${module.tiller.service_account}"
  namespace       = "${module.tiller.namespace}"
  install_tiller  = false

  kubernetes {
    host                   = "${module.gke.host}"
    cluster_ca_certificate = "${base64decode(module.gke.cluster_ca_certificate)}"
  }
}

module "nginx_ingress" {
  source = "git::https://github.com/lsst-sqre/terraform-nginx-ingress.git//?ref=master"

  chart_version    = "1.1.2"
  namespace        = "nginx-ingress"
  namespace_create = true
}
