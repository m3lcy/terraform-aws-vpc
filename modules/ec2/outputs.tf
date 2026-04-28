output "instance_ids" {
  description = "Map of Instance IDs keyed by instance name"
  value       = { for k, i in aws_instance.this : k => i.id }
}

output "instance_private_ips" {
  description = "Map of Private IPs keyed by instance name"
  value       = { for k, i in aws_instance.this : k => i.private_ip }
}

output "instance_az" {
  description = "Map of AZs keyed by instance name"
  value       = { for k, i in aws_instance.this : k => i.availability_zone }
}

output "instance_profile_arn" {
  description = "ARN of the IAM instance profile attached to all instances"
  value       = aws_iam_instance_profile.ssm.arn
}