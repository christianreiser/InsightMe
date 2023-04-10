terraform {
  # provider google
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.49.0"
    }
  }

  # save state in Google Cloud Bucket
  backend "gcs" {
    bucket      = "insightme-terraform-state"
    prefix      = "terraform/state"
    credentials = "~/Downloads/terraform-im.json"
  }
}

# We define the "google" provider with the project and the general region + zone
provider "google" {
  credentials = file("~/Downloads/terraform-im.json")
  project     = var.project_id
  region  = "europe-west3"
  zone    = "europe-west1-b"
}

resource "google_cloudbuild_trigger" "dev_incl_backend" {
  project  = "bubbly-reducer-279907"
  name     = "dev_incl_backend_trigger"
  disabled = false

  trigger_template {
    repo_name   = "christianreiser/InsightMe"
    branch_name = "dev_incl_backend"
  }

  filename = "cloudbuild.yaml"
}



