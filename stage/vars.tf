variable "ECR_REPO" {
  type = string
}

variable "IAM_ROLE" {
  type = string
}

variable "AWS_REGION" {
  type = string
}
variable "availability_zone" {
	type = string
}

variable "key_name" {
    type = string
}

variable "LAUNCH_TEMPLATE_NAME" {
  type = string
}

locals {
  keys = {
    ECR_REPO = var.ECR_REPO
    IAM_ROLE = var.IAM_ROLE
    ENV = "stage"
    TAG = "stage"
  }
}

