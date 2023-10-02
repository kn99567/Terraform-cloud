locals {
  project_id           = "adept-presence-396401"
  project_region       = "us-central1"
  bucket_location      = "US"
  bucket_lifecycle_age = 360
}

resource "google_service_account" "sa-tfcloud-demo" {
  account_id   = "sa-tfcloud-demo"
  display_name = "sa-tfcloud-demo"
}

resource "google_storage_bucket" "tfcloud-bucket" {
  name     = format("dev-tfcloud-demo-%s", local.project_id)
  location = local.bucket_location
  lifecycle_rule {
    condition {
      age = local.bucket_lifecycle_age
    }
    action {
      type = "Delete"
    }
  }
}

resource "google_storage_bucket_iam_member" "tfcloud-storage-admin" {
  bucket  = google_storage_bucket.tfcloud-bucket.name
  role    = "roles/storage.admin"
  member  = format("serviceAccount:%s", google_service_account.sa-tfcloud-demo.email)
}
