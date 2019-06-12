variable "regions" {
  type = list(string)
  description = "Regions in which to create managed instance groups."
}

variable "name" {
  type = string
  description = "Name format to use when creating groups. {region} is replaced with the group's region."
}

variable "instance_template_link" {
  type = string
  description = "Link to the instance template to assign to the instance group."
}

variable "min_replicas" {
  type = number
  default = 1
  description = "Minimum number of instances to scale down to (when autoscaling is enabled)."
}

variable "max_replicas" {
  type = number
  default = 3
  description = "Maximum number of instances to scale to (when autoscaling is enabled)."
}

variable "cooldown_period" {
  type = number
  default = 60
  description = "Length of time (in seconds) each new instance is allowed to boot before fetching information from it."
}


variable "autoscaling" {
  type = list
  default = []
  description = "Parameters with which to implement autoscaling."
}

variable "target_size" {
  type = number
  default = 1
  description = "Target size of instance group, when autoscaling is not in effect."
}

locals {
  autoscaling_metrics = [
    for item in var.autoscaling:
      item
    if contains(keys(item), "metric")
  ]

  autoscaling_cpu = {
    for item in var.autoscaling:
      "cpu" => item
    if contains(keys(item), "cpu")
  }
}
