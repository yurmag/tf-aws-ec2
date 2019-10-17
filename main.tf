/* Description

This module creates an EC2 instance and attaches ENI(s) to it.
  
Module minimal usage:

module "cisco_01" {
  source = "../modules/05_ec2"

  ami          = "ami-0026dc643b0d77fc5"
  ec2_type     = "c5.xlarge"
  keypair      = "peering-eu-central-1"

  eni_primary_attr         = {
    subnet            = "subnet-0cc32104605140510"
    description       = "iperf_01_eth0"
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

  eni_secondary_attr         = {
    subnet            = "subnet-0cc3210460514f10"
    description       = "iperf_01_eth0"
    source_dest_check = "false"
  }
  eni_secondary_sg_rule_list = [
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
    Name = "iperf_1",
  }
}

output "ec2" {
  description = "EC2 resource"
  value = aws_instance.this
}

output "eip" {
  description = "EIP resource"
  value = aws_eip.this
}
*/

resource "aws_network_interface" "primary" {
  # subnet_id is a required filed
  subnet_id         = var.eni_primary_attr["subnet"]
  description       = lookup(var.eni_secondary_attr, "description", "")
  source_dest_check = lookup(var.eni_secondary_attr, "source_dest_check", "false")
  security_groups   = [aws_security_group.primary.id]

  tags = var.tags
}
 resource "aws_eip" "this" {
  vpc               = true
  network_interface = aws_network_interface.primary.id
  tags              = var.tags
}

resource "aws_instance" "this" {
  ami           = var.ami
  instance_type = var.ec2_type
  key_name      = var.keypair

  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.primary.id
  }

  root_block_device {
    volume_type = var.root_volume_type
  }

  tags        = var.tags
  volume_tags = var.tags
}

resource "aws_network_interface" "secondary" {
  count = (lookup(var.eni_secondary_attr, "subnet", "") != "") ? 1 : 0

  # subnet_id is a required filed
  subnet_id         = var.eni_secondary_attr["subnet"]
  description       = lookup(var.eni_secondary_attr, "description", "")
  source_dest_check = lookup(var.eni_secondary_attr, "source_dest_check", "false")
  security_groups   = [aws_security_group.secondary[0].id]

  tags = var.tags
}

resource "aws_network_interface_attachment" "this" {
  #the number of identical resources to create
  count = (lookup(var.eni_secondary_attr, "subnet", "") != "") ? 1 : 0

  instance_id          = aws_instance.this.id
  network_interface_id = aws_network_interface.secondary[0].id
  device_index         = 1
}

