### SG fot Primary ENI

resource "aws_security_group" "primary" {
  vpc_id      = var.vpc_id
  name_prefix = format("%s-%s", var.tags["Name"], "primary")

  tags = var.tags
}

resource "aws_security_group_rule" "primary" {
  count = length(var.eni_primary_sg_rule_list)

  type        = lookup(var.eni_primary_sg_rule_list[count.index], "type")
  from_port   = lookup(var.eni_primary_sg_rule_list[count.index], "from_port")
  to_port     = lookup(var.eni_primary_sg_rule_list[count.index], "to_port")
  protocol    = lookup(var.eni_primary_sg_rule_list[count.index], "protocol")
  cidr_blocks = split(" ", lookup(var.eni_primary_sg_rule_list[count.index], "cidr_blocks"))

  security_group_id = aws_security_group.primary.id
}

### SG for Secondary ENI (optional)
resource "aws_security_group" "secondary" {
  count = (length(var.eni_secondary_sg_rule_list) != 0) ? 1 : 0

  vpc_id      = var.vpc_id
  name_prefix = format("%s-%s", var.tags["Name"], "secondary")

  tags = var.tags
}

resource "aws_security_group_rule" "secondary" {
  count = length(var.eni_secondary_sg_rule_list)

  type        = lookup(var.eni_secondary_sg_rule_list[count.index], "type")
  from_port   = lookup(var.eni_secondary_sg_rule_list[count.index], "from_port")
  to_port     = lookup(var.eni_secondary_sg_rule_list[count.index], "to_port")
  protocol    = lookup(var.eni_secondary_sg_rule_list[count.index], "protocol")
  cidr_blocks = split(" ", lookup(var.eni_secondary_sg_rule_list[count.index], "cidr_blocks"))

  security_group_id = aws_security_group.secondary[0].id
}