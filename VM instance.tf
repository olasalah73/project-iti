resource "google_compute_instance" "vm_instance" {
  name         = "terraform-instance1"
  project      = " ola-project-337613"
  machine_type = "f1-micro"
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    network    = "task-network"
    subnetwork = "mangement"
    access_config {
    }
  }
}