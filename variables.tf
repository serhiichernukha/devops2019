variable "project" {
  description = "Project unic ID"
  default = "gcptask-256312"
}

variable "region" {
  default = "us-east1"
}

variable "zone" {
  default = "us-east1-b"
}

variable "default_network" {
  description = "Default VPC network"
  type = string
  default = "projects/gcptask-256312/global/networks/default"
}

variable "image" {
  default = "centos-cloud/centos-8-v20191115"
      }

variable "mtype" {
  default = "n1-standard-1"
}

variable "servername" {
  default = "jenkinsmaster"
}

variable "clustername" {
  default = "my-kuber"
}
