terraform {
  required_version = ">0.12.0"
}

variable "tags" {
  type        = map(string)
  description = "Tags (otpional variable)"
  default     = {}
}

### Common

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "ami" {
  type        = string
  description = "Specify AMI to used for EC2 instance"
}

variable "ec2_type" {
  type        = string
  description = "Specify the type of EC2 instance."
}

variable "keypair" {
  type        = string
  description = "Specify existing keepair for access EC2 instance."
}

### Root block device

variable "root_volume_type" {
  description = "Specify volume type for the root volume"
  default = "gp2"
}

### Network

variable "eni_primary_attr" {
  type        = map(string)
  description = "Specify the parameters of the primary ENI"
}

variable "eni_primary_sg_rule_list" {
  type        = list
  description = "Specify SG rules (list of maps) for the primary ENI."
}

variable "eni_secondary_attr" {
  type        = map(string)
  description = "Specify the parameters of the secondary ENI"

  default = {}
}

variable "eni_secondary_sg_rule_list" {
  type        = list
  description = "Specify SG rules (list of maps) for the secondary ENI."

  default = []
}