resource "google_colab_runtime_template" "my_runtime_template" {
  name         = "runtime-template-1"
  display_name = "Runtime template 1"
  location     = "us-west1"

  machine_spec {
    machine_type = "e2-standard-4"
  }

  network_spec {
    enable_internet_access = true
  }
}

resource "google_storage_bucket" "output_bucket" {
  name                        = "meridian_bucket_perpetual"
  location                    = "US"
  force_destroy               = true
  uniform_bucket_level_access = true
}

resource "google_storage_bucket_object" "notebook" {
  name   = "meridian_lite_weekly.ipynb"
  bucket = google_storage_bucket.output_bucket.name
  source = "${path.module}/notebook/meridian_lite_weekly.ipynb"
}

resource "google_storage_bucket_object" "csv" {
  name   = "meridian_lite_weekly.csv"
  bucket = google_storage_bucket.output_bucket.name
  source = "${path.module}/csv/meridian_lite_weekly.csv"
}

resource "google_colab_schedule" "schedule" {
  display_name             = "full-schedule"
  location                 = google_colab_runtime_template.my_runtime_template.location
  allow_queueing           = true
  max_concurrent_run_count = 1
  cron                     = "TZ=America/Lima 0 * * * *"
  max_run_count            = 5
  start_time               = "2025-03-06T16:20:23Z"
  end_time                 = "2025-03-07T16:20:23Z"

  desired_state = "ACTIVE"

  create_notebook_execution_job_request {
    notebook_execution_job {
      display_name      = "Notebook execution"
      execution_timeout = "86400s"

      gcs_notebook_source {
        uri        = "gs://${google_storage_bucket_object.notebook.bucket}/${google_storage_bucket_object.notebook.name}"
        generation = google_storage_bucket_object.notebook.generation
      }
      notebook_runtime_template_resource_name = "projects/${google_colab_runtime_template.my_runtime_template.project}/locations/${google_colab_runtime_template.my_runtime_template.location}/notebookRuntimeTemplates/${google_colab_runtime_template.my_runtime_template.name}"

      gcs_output_uri  = "gs://${google_storage_bucket.output_bucket.name}"
      service_account = "terraform-service-account@yuri-andrade.iam.gserviceaccount.com"
    }
  }

  depends_on = [
    google_colab_runtime_template.my_runtime_template,
    google_storage_bucket.output_bucket,
    google_storage_bucket_object.notebook,
  ]
}
