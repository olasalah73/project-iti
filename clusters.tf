resource "google_container_cluster" "cluster" {
  name       = "instance-cluster3"
  location   = "asia-east1"
  network    = "task-network"
  subnetwork = "restricted"
  
  private_cluster_config {
    master_ipv4_cidr_block  = "172.16.0.0/24"
    enable_private_nodes    = true
    enable_private_endpoint = true
  }

  master_authorized_networks_config {
    cidr_blocks {
      cidr_block = "10.0.1.0/24"
    }
  }
  ip_allocation_policy {
    cluster_ipv4_cidr_block  = "10.2.0.0/24"
    services_ipv4_cidr_block = "192.168.0.0/24"
  }

  remove_default_node_pool = true
  initial_node_count       = 1
}

resource "google_service_account" "" {
  account_id   = "109022936701258668912"
  display_name = "ola-project-2"
}

resource "google_project_iam_binding" "" {
  project = ""
  role    = "roles/container.admin"

  members = [
    "serviceAccount:${ola-project-2@ola-project-337613.iam.gserviceaccount.com  }"
  ]
}

resource "google_container_node_pool" "nodepool0" {
  name       = "nodepool0"
  location   = "asia-east1"
  cluster    = "instance-cluster3"
  node_count = 1

  node_config {
    preemptible  = false
    machine_type = "f1-micro"
    service_account = google_service_account..email
    oauth_scopes = []
  }
}