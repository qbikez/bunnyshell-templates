variable "instance_suffix" {
  type        = string
  description = "Name of the storage account"
  default = "local"
}

variable "location" {
  type        = string
  description = "Location of the storage account (i.e. westeurope)"
  default = "westeurope"
}

locals {
  tags = {
    environment = "dev"
    owner       = "bunnyshell"
    project     = "bunnyshell"
    terraform   = true
  }
}