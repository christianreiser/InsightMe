
#Enable the bigquery API
resource "google_project_service" "bigquery" {
  project            = var.project_id
  service            = "compute.googleapis.com"
  disable_on_destroy = false
}

# enable the Cloud Build API
resource "google_project_service" "cloudbuild" {
  project            = var.project_id
  service            = "cloudbuild.googleapis.com"
  disable_on_destroy = false
}

# Enable the Cloud Resource Manager API
resource "google_project_service" "cloudresourcemanager" {
  project            = var.project_id
  service            = "cloudresourcemanager.googleapis.com"
  disable_on_destroy = false
}

# enable IAM API
resource "google_project_service" "iam" {
  project            = var.project_id
  service            = "iam.googleapis.com"
  disable_on_destroy = false
}

# enable cloud scheduler API
resource "google_project_service" "cloudscheduler" {
  project            = var.project_id
  service            = "cloudscheduler.googleapis.com"
  disable_on_destroy = false
}

# enable cloud run API
resource "google_project_service" "cloudrun" {
  project            = var.project_id
  service            = "run.googleapis.com"
  disable_on_destroy = false
}

#enable the Fitness API
resource "google_project_service" "fitness" {
  project            = var.project_id
  service            = "fitness.googleapis.com"
  disable_on_destroy = false
}

# enable secret manager API
resource "google_project_service" "secretmanager" {
  project            = var.project_id
  service            = "secretmanager.googleapis.com"
  disable_on_destroy = false
}