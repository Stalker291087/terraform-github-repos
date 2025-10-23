# variable for resource count
variable "repo-max" {
  type        = number
  description = "Number of resources to be created"

  validation {
    condition     = var.repo-max <= 5
    error_message = "No more deploy more than 5 git repositories."
  }
}

variable "env" {
  type        = string
  description = "Environment where the deployment is going to be deployed"
  #default = "value"

  validation {
    condition     = contains(["dev", "prod"], var.env)
    error_message = "Environment needs to be 'dev' or 'prod'"
  }
}

variable "repositories" {
  type        = map(map(string))
  description = "List of repositories."

  validation {
    condition     = length(var.repositories) <= var.repo-max
    error_message = "No more than 5 repositories can be deployed at the same run."
  }
}

variable "github_token" {
  type        = string
  description = "GitHub Token"
}