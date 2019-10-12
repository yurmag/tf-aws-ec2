# tf-aws-ec2
This module creates an EC2 instance with two interfaces: primary and secondary. 
Secondary interface is optional:
 - eni_secondary_attr
 - eni_secondary_sg_rule_list
  
Module usage example:

```
module "amz2_01" {
  source = "git::https://github.com/yurmag/tf-aws-ec2.git"

  vpc_id   = "vpc-98867575453rfg"
  ami      = "ami-094d4d00fd7462815"
  ec2_type = "t2.micro"
  keypair  = "keypair_central"

  eni_primary_attr    = {
    subnet            = "subnet-0cc32104605140510"
    description       = "amz2_01_pr"
    source_dest_check = "false"
  }
  eni_primary_sg_rule_list = [
    {
      type        = "ingress"
      from_port   = "0"
      to_port     = "0"
      protocol    = "-1"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      type        = "egress"
      from_port   = "0"
      to_port     = "0"
      protocol    = "-1"
      cidr_blocks = "0.0.0.0/0"
    },    
  ]

  tags = {
    Name = "amz2_01",
  }
}

output "amz2_01_ec2_id" {
  value = module.amz2_01.ec2.id
}

output "amz2_01_eip" {
  value = module.amz2_01.eip.public_ip
}
```
