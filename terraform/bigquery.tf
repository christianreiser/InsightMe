resource "google_bigquery_dataset" "dataset" {
  dataset_id                  = "chrisi_reiser_at_gmail_com"
  friendly_name               = "Christian Reiser"
  description                 = "Dataset of Christian Reiser"
  location                    = "EU"
  labels = {
    env = "default"
  }

  access {
    role          = "OWNER"
    user_by_email = google_service_account.bqowner.email
  }

  access {
    role   = "READER"
    domain = "hashicorp.com"
  }
}

resource "google_service_account" "bqowner" {
  account_id = "bqowner"
    lifecycle {
      ignore_changes      = [all]
      create_before_destroy = true
    }

    depends_on = [
    google_project_service.cloudresourcemanager,
    google_project_service.bigquery,
    google_project_service.iam
  ]
}

