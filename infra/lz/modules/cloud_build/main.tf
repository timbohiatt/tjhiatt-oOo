locals {
  project_id = var.project_id
  deployment_project = var.deployment_project
  repo_owner = var.repo_owner 
  repo_name = var.repo_name 
  env = var.env
  branch = var.branch
}

resource "google_cloudbuild_trigger" "lz-trigger-sdod-ui" {
  name    = "lz-trigger-${local.project_id}-ui-${local.env}"
  project = local.project_id              //Project in Which Trigger is Created
  github {
    owner = local.repo_owner
    name = local.repo_name
    push {
        branch = local.branch
    }
  }

  substitutions = {
    _ENV             = local.env
    _PROJECT_ID      = local.deployment_project //Project in which Terraform is Deployed
  }

  filename = "ui/cloudbuild.yaml"
}