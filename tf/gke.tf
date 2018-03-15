provider "google" {
  project = "${var.google_project}"
  region  = "us-central1"
  zone    = "us-central1-b"
}

resource "google_container_cluster" "gitlfs" {
  name               = "${var.service_name}-${var.env_name}"
  initial_node_count = 3
  min_master_version = "1.9.4-gke.1"

  addons_config {
    http_load_balancing {
      disabled = false
    }

    kubernetes_dashboard {
      disabled = false
    }

    horizontal_pod_autoscaling {
      disabled = false
    }
  }

  maintenance_policy {
    daily_maintenance_window {
      start_time = "03:00"
    }
  }

  node_config {
    image_type   = "COS"
    machine_type = "n1-standard-1"

    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
}
