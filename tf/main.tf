terraform {
  backend "s3" {}
}

provider "template" {
  version = "~> 1.0"
}

module "gke" {
  source             = "github.com/lsst-sqre/terraform-gke-std"
  name               = "${local.gke_cluster_name}"
  google_project     = "${var.google_project}"
  initial_node_count = 3
}
