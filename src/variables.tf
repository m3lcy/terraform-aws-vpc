variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string

  validation {
    condition = can(cidrnetmask(var.vpc_cidr))
    error_message = "vpc_cidr must be a valid CIDR block"
  }
}

variable "name_prefix" {
  description = "Prefix applied to all resource names"
  type        = string
}

variable "az_count" {
  description = "Number of Availability Zones to use"
  type        = number
  default     = 3

  validation {
    condition     = var.az_count >= 2 && var.az_count <= 6
    error_message = "az_count must be between 2 and 6"
  }
}
