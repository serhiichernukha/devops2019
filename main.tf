provider "google" {
  credentials = file("GCPTask-f74802c30cba.json")
  project     = var.project
  region      = var.region
  zone        = var.zone
}


resource "google_compute_instance" "jenkinsmaster" {
  name         = var.servername
  machine_type = var.mtype
  tags         = ["http-server", "https-server"]

  boot_disk {
    initialize_params {
      image = var.image
    }
  }

  service_account {
    scopes = ["cloud-platform"]
  }
  network_interface {
    network = "default"
    access_config {      #this block gives our instance external ip adress
          }
  }
  metadata_startup_script = file("./metadata.sh")
}


resource "google_container_cluster" "my-cluster" {
  name     = var.clustername
  location = var.region
  # remove_default_node_pool = true
  initial_node_count       = 1

    master_auth {
  client_certificate_config {
    issue_client_certificate = false
    }
  }

  node_config {
      oauth_scopes = [
        "https://www.googleapis.com/auth/compute",
        "https://www.googleapis.com/auth/devstorage.read_only",
        "https://www.googleapis.com/auth/logging.write",
        "https://www.googleapis.com/auth/monitoring",
      ]

      tags = ["app-cluster"]
    }
}
