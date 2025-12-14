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

variable "common_tags" {
  description = "Tags applied to all resources"
  type = map(string)
  default = {}
}

variable "vpc_tags" {
  description = "Aditional tags to apply to the VPC"
  type = map(string)
  default = {}
}

variable "public_subnet_tags" {
  description = "Additional tags applied only to public subnets"
  type = map(string)
  default = {}
}

variable "private_subnet_tags" {
  description = "Additional tags applied only to private subnets"
  type = map(string)
  default = {}
}

variable "enable_nat_gateway" {
  description = "Create NAT gateways (set false to save cost)"
  type = bool
  default = true
}