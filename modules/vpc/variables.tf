variable "vpc_cidr" {
  description = "The CIDR block for the enterprise VPC"
  type        = string
  validation {
    condition     = can(cidrnetmask(var.vpc_cidr))
    error_message = "Must be a valid IPv4 CIDR block."
  }
}

variable "subnet_config" {
  description = "Map of subnet configurations (VLAN mapping)"
  type = map(object({
    cidr_block = string
    az         = string
    is_public  = bool
  }))
}

variable "name_prefix" {
  description = "Prefix applied to all resource names"
  type        = string
}

variable "management_ssh_cidrs" {
  description = "CIDR blocks allowed to SSH into the management security group. Use [] to disable SSH access."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "enable_nat_gateway" {
  description = "Create NAT gateways"
  type        = bool
  default     = false
}