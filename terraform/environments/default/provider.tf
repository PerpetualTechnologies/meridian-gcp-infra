provider "google" {
  credentials = file("/tmp/gcp_key.json")
  project     = var.project_id
  region      = "us-west1"
}
