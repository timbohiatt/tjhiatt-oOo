variable "ENV" {
  type        = string
  description = "Three Char code representing Environment [eg: DEV, TST, PRD] ."

  validation {
    condition     = ((var.ENV) != null && length(var.ENV) == 3)
    error_message = "The PROJECT_PREFIX can not be NULL. It is Required."
  }
}

variable "PROJECT_PREFIX" {
  type        = string
  description = "The Prefix Used to represent all Resources in this Project."
  default     = "db-pso-sdod"

  validation {
    condition     = ((var.PROJECT_PREFIX) != null && length(var.PROJECT_PREFIX) >= 4)
    error_message = "The PROJECT_PREFIX can not be NULL. It is Required."
  }
}

variable "GCP_PROJECT" {
  type        = string
  description = "The GCP Project that all your resources will be associated with."

  validation {
    condition     = ((var.GCP_PROJECT) != null && length(var.GCP_PROJECT) >= 4)
    error_message = "The GCP_PROJECT can not be NULL. It is Required."
  }
}

variable "GCP_REGION" {
  type        = string
  description = "The GCP Region your project primarily operates in (eg europe-west1)"
  default = "europe-west1"

  validation {
    condition     = (var.GCP_REGION) != null
    error_message = "The GCP_REGION can not be NULL. It is Required."
  }
}

variable "GCP_ZONE" {
  type        = string
  description = "The GCP Zone your project primarily operates in (eg europe-west1-a)"
  default = "europe-west1-a"

  validation {
    condition     = (var.GCP_ZONE) != null
    error_message = "The GCP_ZONE can not be NULL. It is Required."
  }
}

variable "IMAGE_VERSION" {
  type        = string
  description = "Container Image Version that you wish to deploy to Cloud Run"
  default = "latest"
}

