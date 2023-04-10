# scheduler that triggers the extraction of data via pubsub

# Topic data_import-data-topic should be in the format "projects/<PROJECT_ID>/topics/<TOPIC_ID>" var.project_id/data_import-data-topic/data_import-data-topic
resource "google_cloud_scheduler_job" "extraction_scheduler" {
  region      = "europe-west1"
  name        = "extraction-scheduler"
  description = "Triggers the extraction of data"
  schedule    = "*/60 * * * *" # format: minute hour day_of_month month day_of_week
  time_zone   = "UTC"
  pubsub_target {
    topic_name = "projects/${var.project_id}/topics/${google_pubsub_topic.extract_data_topic.name}"
    data       = base64encode(jsonencode({
      "message" = "extract data"
    }))
  }
}

# topic that triggers the extraction of data
resource "google_pubsub_topic" "extract_data_topic" {
  name = "extract-data-topic"
}
