terraform {
  required_version = ">= 0.14"

  required_providers {
    google = ">= 3.3"
  }
}

provider "google" {
  project     = var.project_id
  region      = var.region
  zone        = var.zone
  credentials = "../keys/finalkey.json"
}

resource "google_compute_instance" "default" {
  name         = "final-project"
  machine_type = "n2-standard-2"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      size = "30"
      type = "pd-balanced"
    }
  }

  // Local SSD disk
  scratch_disk {
    interface = "SCSI"
  }

  network_interface {
    network = "default"
    access_config {
     // Include this section to give the VM an external ip address
   }
  }

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = "730679532727-compute@developer.gserviceaccount.com"
    scopes = ["cloud-platform"]
  }
}