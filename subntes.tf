resource "google_compute_subnetwork" "subnet" {
    name           = "mangement"
    ip_cidr_range  = "10.0.0.0/24"
    region         = "asia_east1"
    network        = google_compute_network.vpc_network.id
}


resource "google_compute_subnetwork" "subnet" {
    name           = "restricted"
    ip_cidr_range  = "10.1.0.0/24"
    region         = "asia_east1"
    network        = google_compute_network.vpc_network.id
}

resource "google_compute_router" "router" {
  name    = "my-router"
  region  = google_compute_subnetwork.subnet.region
  network = google_compute_network.net.id

  bgp {
    asn = 64514
  }
}

resource "google_compute_address" "address" {
  count  = 2
  name   = "nat-manual-ip-${count.index}"
  region = google_compute_subnetwork.subnet.region
}

resource "google_compute_router_nat" "nat_manual" {
  name   = "my-router-nat"
  router = google_compute_router.router.name
  region = google_compute_router.router.region

  nat_ip_allocate_option = "MANUAL_ONLY"
  nat_ips                = google_compute_address.address.*.self_link

  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  subnetwork {
    name                    = google_compute_subnetwork.subnet.id
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }
}