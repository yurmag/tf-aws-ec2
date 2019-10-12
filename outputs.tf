output "ec2" {
  description = "EC2 resource"
  value       = aws_instance.this
}

output "eip" {
  description = "EIP resource"
  value       = aws_eip.this
}

