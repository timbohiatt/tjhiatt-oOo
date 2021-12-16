
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
  Terraform State
*/
terraform {
  backend "gcs" {
    bucket = "tf-state-timhiatt-ooo" 
    prefix = "terraform/state"
  }
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
  Resources: Container Registry
*/
resource "google_container_registry" "registry" {
  project = data.google_project.project.project_id
  location = "EU"
  depends_on = [google_project_service.project]
}

module "cloud-build-dev" {
  source = "./modules/cloud_build"
  project_id = data.google_project.project.project_id
  deployment_project = data.google_project.project.project_id
  env = var.ENV
  branch = "^develop$"
  repo_owner = "timbohiatt"
  repo_name = "tjhiatt-oOo"
}