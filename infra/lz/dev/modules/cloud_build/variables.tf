variable "project_id" {
  type        = string
  description = "The GCP Project that all your resources will be associated with."

  validation {
    condition     = ((var.project_id) != null && length(var.project_id) >= 4)
    error_message = "The project_id can not be NULL. It is Required."
  }
}

variable "deployment_project" {
  type        = string
  description = "The GCP Project that all your resources will be deployed into."

  validation {
    condition     = ((var.deployment_project) != null && length(var.deployment_project) >= 4)
    error_message = "The deployment_project can not be NULL. It is Required."
  }
}


variable "env" {
  type        = string
  description = "The env that the Cloud Build job will trigger the job from."

  validation {
    condition     = ((var.env) != null)
    error_message = "The env can not be NULL. It is Required."
  }
}

variable "branch" {
  type        = string
  description = "The Branch that the Cloud Build job will trigger the job from."

  validation {
    condition     = ((var.branch) != null)
    error_message = "The branch can not be NULL. It is Required."
  }
}

variable "repo_owner" {
  type        = string
  description = "The Github Repo Owner that the Cloud Build job will trigger the job from."
}

variable "repo_name" {
  type        = string
  description = "The Github Repo Owner that the Cloud Build job will trigger the job from."
}