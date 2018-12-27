provider "template" {
  version = "~> 1.0"
}

module "gke" {
  source             = "github.com/lsst-sqre/terraform-gke-std"
  name               = "${local.gke_cluster_name}"
  google_project     = "${var.google_project}"
  initial_node_count = 3
}

provider "kubernetes" {
  version = "~> 1.1"

  host                   = "${module.gke.host}"
  client_certificate     = "${base64decode(module.gke.client_certificate)}"
  client_key             = "${base64decode(module.gke.client_key)}"
  cluster_ca_certificate = "${base64decode(module.gke.cluster_ca_certificate)}"
}

provider "aws" {
  version = "~> 1.21"
  region  = "${var.aws_primary_region}"
  alias   = "primary"
}

provider "aws" {
  # providers are initialized early and can't use a local var to DRY version
  version = "~> 1.21"
  region  = "${var.aws_backup_region}"
  alias   = "backup"
}

provider "helm" {
  kubernetes {
    host                   = "${module.gke.host}"
    client_certificate     = "${base64decode(module.gke.client_certificate)}"
    client_key             = "${base64decode(module.gke.client_key)}"
    cluster_ca_certificate = "${base64decode(module.gke.cluster_ca_certificate)}"
  }
}
