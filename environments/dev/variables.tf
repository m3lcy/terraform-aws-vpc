variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Target environment (prod/staging/dev)"
  type        = string

  validation {
    condition     = contains(["prod", "staging", "dev"], var.environment)
    error_message = "Environment must be prod, staging, or dev."
  }
}

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
  description = "CIDR blocks allowed to SSH into the management security group. Empty list disables SSH access."
  type        = list(string)
  default     = []
}
