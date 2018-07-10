terraform {
  backend "s3" {}
}

provider "template" {
  version = "~> 1.0"
}

module "gke" {
  source             = "github.com/lsst-sqre/terraform-gke-std"
  name               = "${data.template_file.gke_cluster_name.rendered}"
  google_project     = "${var.google_project}"
  initial_node_count = 3
}
