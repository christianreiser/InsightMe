# version 2 cloud function to data_import data from G Fit and insert into BigQuery. Triggered by a pubsub message.
resource "google_cloudfunctions2_function" "extract_g_fit_function" {
  name        = "extract-g-fit-function"
  description = "Extract data from G Fit and insert into BigQuery"
  location    = "europe-west3"
  event_trigger {
    event_type = "google.cloud.pubsub.topic.v1.messagePublished"
    pubsub_topic = google_pubsub_topic.topic.id
  }

  build_config {
    entry_point = "get_data"
    runtime     = "python310"
    source {
      storage_source {
        bucket = google_storage_bucket.extract_g_fit_bucket.name
        object = google_storage_bucket_object.extract_g_fit_object.name
      }
    }
  }
  # depends on event arc api enabled
  depends_on = [google_project_service.eventarc]
}

resource "google_pubsub_topic" "topic" {
  name = "extract-g-fit-topic"
}

# create the bucket
resource "google_storage_bucket" "extract_g_fit_bucket" {
  name          = "extract-g-fit-bucket"
  location      = "EU"
  force_destroy = true
}

resource "google_storage_bucket_object" "extract_g_fit_object" {
  name       = "extract-g-fit-object"
  bucket     = google_storage_bucket.extract_g_fit_bucket.name
  source     = data.archive_file.extract_g_fit_file.output_path
}

data "archive_file" "extract_g_fit_file" {
  type        = "zip"
  source_dir  = "${path.module}/../backend/data_import/g_fit/"
  output_path = "extract-g-fit.zip"
}