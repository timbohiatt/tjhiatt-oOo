
locals {
  project_region  = var.GCP_REGION
  project_prefix  = var.PROJECT_PREFIX
  project_zone    = var.GCP_ZONE
  

  apis = [
    "dns.googleapis.com", 
    "cloudapis.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "compute.googleapis.com",
    "containerregistry.googleapis.com", 
    //"domains.googleapis.com",
    "run.googleapis.com",
  ]
}

/*
  Data GCP Project Variables
*/
data "google_project" "project" {
  project_id      = var.GCP_PROJECT
}

/*
  Resource: GCP API's and Services
*/
resource "google_project_service" "project" {
  for_each           = toset(local.apis)
  project            = data.google_project.project.project_id
  service            = each.key
  disable_on_destroy = false

  timeouts {
    create = "30m"
    update = "40m"
  }
  //disable_dependent_services = true
}

/*
  Resources: Cloud Run - Portal UI
*/
resource "google_cloud_run_service" "timhiatt-ooo-ui" {
  provider = google-beta
  name     = "${data.google_project.project.project_id}-ui"
  project  = data.google_project.project.project_id
  location = local.project_region
  depends_on = [google_project_service.project]

  metadata {
    annotations = {
      //"run.googleapis.com/ingress" : "internal-and-cloud-load-balancing"
      "run.googleapis.com/ingress" : "all"
    }
  }

  template {
    spec {
      containers {
        image = "gcr.io/${data.google_project.project.project_id}/${data.google_project.project.project_id}-ui:${var.IMAGE_VERSION}"
        ports {
          name = "http1"
          container_port = "80"
        }
        #env {
        #  name = "SOURCE"
        #  value = "remote"
        #}
        #env {
        #  name = "TARGET"
        #  value = "home"
        #}
        #env {
        #  name = "TARGET"
        #  value = "home"
        #}
      }
    }
    metadata {
      annotations = {
        "autoscaling.knative.dev/maxScale"      = "100"
        //"run.googleapis.com/cloudsql-instances" = google_sql_database_instance.instance.connection_name
        "run.googleapis.com/client-name"        = "${data.google_project.project.project_id}-ui"
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
  autogenerate_revision_name = true
  lifecycle {
    ignore_changes = [
        metadata.0.annotations,
    ]
  }
}


data "google_iam_policy" "noauth" {
  binding {
    role = "roles/run.invoker"
    members = [
      "allUsers",
    ]
  }
}

resource "google_cloud_run_service_iam_policy" "noauth" {
  location    = google_cloud_run_service.timhiatt-ooo-ui.location
  project     = google_cloud_run_service.timhiatt-ooo-ui.project
  service     = google_cloud_run_service.timhiatt-ooo-ui.name

  policy_data = data.google_iam_policy.noauth.policy_data
}