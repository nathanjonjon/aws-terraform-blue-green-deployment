variable "AWS_REGION" {
  type = string
}

variable "certificate_arn" {
  type = string
}

locals {
  traffic_dist_map = {
    blue = {
      blue  = 100
      green = 0
    }
    blue-90 = {
      blue  = 90
      green = 10
    }
    split = {
      blue  = 50
      green = 50
    }
    green-90 = {
      blue  = 10
      green = 90
    }
    green = {
      blue  = 0
      green = 100
    }
  }
}
variable "traffic_distribution" {
  description = "Levels of traffic distribution"
  type        = string
  default = "blue"
}