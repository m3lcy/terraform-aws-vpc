variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  validation {
    condition     = can(cidrnetmask(var.vpc_cidr))
    error_message = "Must be a valid IPv4 CIDR block."
  }
}

variable "environment" {
  description = "Target environment (prod/staging/dev)"
  type        = string
  validation {
    condition     = contains(["prod", "staging", "dev"], var.environment)
    error_message = "Environment must be prod, staging, or dev."
  }
}

variable "subnet_config" {
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
  type    = list(string)
  default = []
}

variable "enable_flow_logs" {
  type    = bool
  default = false
}

variable "flow_log_traffic_type" {
  type    = string
  default = "ALL"
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "tgw_routes" {
  description = "List of TGW routes to add to private route tables"
  type = list(object({
    destination_cidr = string
    tgw_id           = string
  }))
  default = []
}