
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
  Terraform State
*/
/*data "terraform_remote_state" "google"{
  backend = "gcs"
  config = {
    bucket = "tf-state-timhiatt-ooo" 
    prefix = "terraform/state"
  }
  depends_on = [data.google_project.project]
}*/

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


resource "time_sleep" "google_project_service_apis_enabling" {
  depends_on = [
    google_project_service.project
  ]

  create_duration = "1m"
}


/*
  Resources: Container Registry
*/
resource "google_container_registry" "registry" {
  project = data.google_project.project.project_id
  location = "EU"
  depends_on = [google_project_service.project]
}


/*
  Resources: Cloud Run - Portal UI
*/
/*resource "google_cloud_run_service" "timhiatt-ooo-ui" {
  provider = google-beta
  name     = "${data.google_project.project.project_id}-ui"
  project  = data.google_project.project.project_id
  location = local.project_region
  depends_on = [google_project_service.project]

  metadata {
    annotations = {
      "run.googleapis.com/ingress" : "internal-and-cloud-load-balancing"
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
      }
    }
    metadata {
      annotations = {
        "autoscaling.knative.dev/maxScale"      = "100"
        //"run.googleapis.com/cloudsql-instances" = google_sql_database_instance.instance.connection_name
        "run.googleapis.com/client-name"        = "ooo-ui"
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

/*
resource "google_storage_bucket" "timhiatt-ooo" {
  name          = "timhiatt-ooo"
  project       = data.google_project.project.project_id
  location      = "EU"
  force_destroy = false
  uniform_bucket_level_access = true

  cors {
    origin          = ["http://image-store.com"]
    method          = ["GET", "HEAD", "PUT", "POST", "DELETE"]
    response_header = ["*"]
    max_age_seconds = 3600
  }
}*/



module "cloud-build-dev" {
  source = "./modules/cloud_build"
  project_id = data.google_project.project.project_id
  deployment_project = data.google_project.project.project_id
  env = var.ENV
  branch = "^develop$"
  repo_owner = "timbohiatt"
  repo_name = "tjhiatt-oOo"
}