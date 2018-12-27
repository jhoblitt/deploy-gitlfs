module "gke" {
  source             = "git::https://github.com/lsst-sqre/terraform-gke-std.git//?ref=master"
  name               = "${local.gke_cluster_name}"
  google_project     = "${var.google_project}"
  gke_version        = "latest"
  initial_node_count = 3
  machine_type       = "n1-standard-1"
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
