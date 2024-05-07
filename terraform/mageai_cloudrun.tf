variable "mageai_app_name" {
  type        = string
  description = "Application Name"
  default     = "mageai"
}

resource "google_filestore_instance" "mageai-filestore" {
  name     = "${var.mageai_app_name}"
  location = var.zone
  tier     = "BASIC_HDD"

  file_shares {
    capacity_gb = 1024
    name        = "share1"
  }

  networks {
    network = "default"
    modes   = ["MODE_IPV4"]
  }
}

resource "google_vpc_access_connector" "connector" {
  name          = "${var.mageai_app_name}-connector"
  ip_cidr_range = "10.8.0.0/28"
  region        = var.region
  network       = "default"
}

resource "google_cloud_run_service" "mageai_cloudrun" {
  name     = var.mageai_app_name
  location = var.region

  template {
    spec {
      containers {
        image = "mageai/mageai:latest"
        ports {
          container_port = 6789
        }
        resources {
          limits = {
            cpu    = "2000m"
            memory = "2G"
          }
        }
        env {
          name  = "FILESTORE_IP_ADDRESS"
          value = google_filestore_instance.mageai-filestore.networks[0].ip_addresses[0]
        }
        env {
          name  = "FILE_SHARE_NAME"
          value = "share1"
        }
        env {
          name  = "GCP_PROJECT_ID"
          value = var.project_id
        }
        env {
          name  = "GCP_REGION"
          value = var.region
        }
        env {
          name  = "GCP_SERVICE_NAME"
          value = var.mageai_app_name
        }
      }
    }

    metadata {
      annotations = {
        "autoscaling.knative.dev/minScale"         = "1"
        "run.googleapis.com/cpu-throttling"        = false
        "run.googleapis.com/execution-environment" = "gen2"
        "run.googleapis.com/vpc-access-connector"  = google_vpc_access_connector.connector.id
        "run.googleapis.com/vpc-access-egress"     = "private-ranges-only"
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }

  autogenerate_revision_name = true
}

data "google_iam_policy" "noauth" {
  binding {
    role = "roles/run.invoker"
    members = [
      "allUsers",
    ]
  }
}

resource "google_cloud_run_service_iam_policy" "noauth" {
  location    = google_cloud_run_service.mageai_cloudrun.location
  project     = google_cloud_run_service.mageai_cloudrun.project
  service     = google_cloud_run_service.mageai_cloudrun.name

  policy_data = data.google_iam_policy.noauth.policy_data
}