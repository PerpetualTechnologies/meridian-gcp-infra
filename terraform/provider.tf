provider "google" {
  credentials = file("/tmp/gcp_key.json")
  project     = var.project_id
  region      = var.region_name
}
