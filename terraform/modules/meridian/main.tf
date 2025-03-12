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

data "archive_file" "function_zip" {
  type        = "zip"
  source_dir  = "${path.module}/function"
  output_path = "${path.module}/function.zip"
}

resource "google_storage_bucket_object" "function_code_zip" {
  name   = "cloud_function_source.zip"
  bucket = "meridian-mmm"
  source = data.archive_file.function_zip.output_path
}

resource "google_storage_bucket_object" "meridian_index_html" {
  name   = "meridian-index-html"
  bucket = "meridian-mmm"
  source = "${path.module}/html/index.html"
}

resource "google_colab_schedule" "meridian_schedule_perpetual" {
  display_name             = "meridian-schedule-perpetual"
  location                 = google_colab_runtime_template.meridian_runtime_template_perpetual.location
  allow_queueing           = true
  max_concurrent_run_count = 1
  cron                     = "TZ=America/Lima 0 0 * * *"
  max_run_count            = 30
  start_time               = "2025-03-08T18:00:00Z"
  end_time                 = "2025-04-08T18:00:00Z"

  desired_state = "ACTIVE"

  create_notebook_execution_job_request {
    notebook_execution_job {
      display_name      = "Notebook execution"
      execution_timeout = "86400s"

      gcs_notebook_source {
        uri        = "gs://${google_storage_bucket_object.notebook.bucket}/${google_storage_bucket_object.notebook.name}"
        generation = google_storage_bucket_object.notebook.generation
      }

      notebook_runtime_template_resource_name = "projects/${google_colab_runtime_template.meridian_runtime_template_perpetual.project}/locations/${google_colab_runtime_template.meridian_runtime_template_perpetual.location}/notebookRuntimeTemplates/${google_colab_runtime_template.meridian_runtime_template_perpetual.name}"
      gcs_output_uri                          = "gs://${google_storage_bucket_object.notebook.bucket}"
      service_account                         = "terraform@meridian-mmm-452218.iam.gserviceaccount.com"
    }
  }

  depends_on = [
    google_colab_runtime_template.meridian_runtime_template_perpetual,
    google_storage_bucket_object.notebook,
    google_storage_bucket_object.csv,
  ]
}

resource "google_cloudfunctions2_function" "list_folders" {
  name        = "meridian-"
  location    = "us-west1"
  description = "Função para listar pastas no bucket e gerar index.html"

  build_config {
    runtime     = "python311"
    entry_point = "list_folders"

    source {
      storage_source {
        bucket = google_storage_bucket.function_bucket.name
        object = google_storage_bucket_object.function_code_zip.name
      }
    }
  }

  service_config {
    max_instance_count = 2
    available_memory   = "256Mi"
    timeout_seconds    = 60
    ingress_settings   = "ALLOW_ALL"
    environment_variables = {
      BUCKET_NAME = "meridian-mmm"
    }
  }

  depends_on = [
    google_storage_bucket.function_bucket,
    google_storage_bucket_object.function_code_zip
  ]
}
