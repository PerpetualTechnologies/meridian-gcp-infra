resource "google_colab_runtime_template" "meridian_runtime_template_perpetual" {
  name         = "meridian-runtime-template-perpetual"
  display_name = "Meridian Runtime Template Perpetual"
  location     = "us-west1"

  machine_spec {
    machine_type = "e2-standard-4"
  }

  network_spec {
    enable_internet_access = true
  }
}

resource "google_storage_bucket_object" "notebook" {
  name   = "meridian_lite_weekly.ipynb"
  bucket = "meridian-mmm"
  source = "${path.module}/notebook/meridian_lite_weekly.ipynb"
}

resource "google_storage_bucket_object" "csv" {
  name   = "meridian_lite_weekly.csv"
  bucket = "meridian-mmm"
  source = "${path.module}/csv/meridian_lite_weekly.csv"
}

resource "google_colab_schedule" "schedule" {
  display_name             = "full-schedule"
  location                 = google_colab_runtime_template.my_runtime_template.location
  allow_queueing           = true
  max_concurrent_run_count = 1
  cron                     = "TZ=America/Lima 0 0 * * *"
  max_run_count            = 5

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
      gcs_output_uri                          = "gs://${google_storage_bucket_object.notebook.bucket}"
      service_account                         = "terraform@meridian-mmm-452218.iam.gserviceaccount.com"
    }
  }

  depends_on = [
    google_colab_runtime_template.my_runtime_template,
    google_storage_bucket.output_bucket,
    google_storage_bucket_object.notebook,
  ]
}
