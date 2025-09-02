##########################################################
#Module: VPC
#
#Index:
#- VPC
#- Subnets
#- NAT Gateway Elastic IP
#- NAT Gateway
#- Internet Gateway
#- Network ACL
#- VPC Endpoint
#- Route Tables
#-- Private Route Tables
#-- Public Route Tables
##########################################################

########## VPC ##########

data "aws_region" "current" {}

resource "aws_vpc" "main" {
  cidr_block    = var.vpc_block
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"

  tags = {
    Name = "${var.vpc_name}-vpc"
  }

}

#resource "aws_flow_log" "main" {
#  log_destination = var.vpc_flow_log_destination #REF EN s3 MODULE
#  log_destination_type = var.vpc_flow_log_type
#  traffic_type = "ALL"
#  vpc_id = aws_vpc.main.id
#
#  tags = {
#    Name = "${var.vpc_name}-vpcflowlog"
#  }
#}

########## SUBNETS ##########

data "aws_availability_zones" "main" {}

module "subnet_calculator" {

  source          = "drewmullen/subnets/cidr"
  base_cidr_block = aws_vpc.main.cidr_block

  networks = [
    {
      name    = "public-1"
      netmask = var.subnet_netmask
    },
    {
      name    = "public-2"
      netmask = var.subnet_netmask
    },
    {
      name    = "public-3"
      netmask = var.subnet_netmask
    },
    {
      name    = "private-1"
      netmask = var.subnet_netmask
    },
    {
      name    = "private-2"
      netmask = var.subnet_netmask
    },
    {
      name    = "private-3"
      netmask = var.subnet_netmask
    },
  ]
}

locals {
  subnets_cidrs         = values(module.subnet_calculator.network_cidr_blocks)
  private_subnets_cidrs = tolist([local.subnets_cidrs[0], local.subnets_cidrs[1], local.subnets_cidrs[2]])
  public_subnets_cidrs  = tolist([local.subnets_cidrs[3], local.subnets_cidrs[4], local.subnets_cidrs[5]])
}

resource "aws_subnet" "private" {
  count                   = var.private_subnets_qty
  vpc_id                  = aws_vpc.main.id
  availability_zone       = data.aws_availability_zones.main.names[count.index]
  cidr_block              = local.private_subnets_cidrs[count.index]
  map_public_ip_on_launch = false
  tags = {
    Name = "${var.vpc_name}-private-subnet-${count.index}"
  }
}

resource "aws_subnet" "public" {
  count                   = var.public_subnets_qty
  vpc_id                  = aws_vpc.main.id
  availability_zone       = data.aws_availability_zones.main.names[count.index]
  cidr_block              = local.public_subnets_cidrs[count.index]
  map_public_ip_on_launch = false
  tags = {
    Name = "${var.vpc_name}-public-subnet-${count.index}"
  }
  depends_on = [
    aws_subnet.private[0],
    aws_subnet.private[1],
    aws_subnet.private[2],
  ]
}

########## NAT GATEWAY ELASTIC IP ##########

resource "aws_eip" "natgw" {
  domain = "vpc"
  tags = {
    Name = "${var.vpc_name}-eip-natgw"
  }
  depends_on = [aws_internet_gateway.main]
}

########## NAT GATEWAY ##########

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.natgw.id
  subnet_id     = aws_subnet.public[0].id
  tags = {
    Name = "${var.vpc_name}-natgw"
  }
  depends_on = [
    aws_subnet.public[0],
    aws_subnet.public[1],
    aws_subnet.public[2],
  ]
}

########## INTERNET GATEWAY ##########

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.vpc_name}-igw"
  }
  depends_on = [
    aws_subnet.public[0],
    aws_subnet.public[1],
    aws_subnet.public[2],
  ]
}

########## NETWORK ACL ##########

resource "aws_network_acl" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.vpc_name}-nacl"
  }
}

resource "aws_network_acl_rule" "rdp" {
  network_acl_id = aws_network_acl.main.id
  egress         = false
  protocol       = "tcp"
  rule_action    = "deny"
  rule_number    = 50
  cidr_block     = "0.0.0.0/0"
  from_port      = 3389
  to_port        = 3389
}

resource "aws_network_acl_rule" "ssh" {
  network_acl_id = aws_network_acl.main.id
  egress         = false
  protocol       = "tcp"
  rule_action    = "deny"
  rule_number    = 60
  cidr_block     = "0.0.0.0/0"
  from_port      = 22
  to_port        = 22
}

resource "aws_network_acl_rule" "ingress_all" {
  network_acl_id = aws_network_acl.main.id
  egress         = false
  protocol       = -1
  rule_action    = "allow"
  rule_number    = 100
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "egress_all" {
  network_acl_id = aws_network_acl.main.id
  egress         = true
  protocol       = -1
  rule_action    = "allow"
  rule_number    = 100
  cidr_block     = "0.0.0.0/0"
}


resource "aws_network_acl_association" "private" {
  network_acl_id = aws_network_acl.main.id
  count          = var.private_subnets_qty
  subnet_id      = aws_subnet.private[count.index].id
}

resource "aws_network_acl_association" "public" {
  network_acl_id = aws_network_acl.main.id
  count          = var.public_subnets_qty
  subnet_id      = aws_subnet.public[count.index].id
}

########## VPC ENDPOINT ##########

resource "aws_vpc_endpoint" "s3" {
  vpc_id       = aws_vpc.main.id
  service_name = "com.amazonaws.us-east-1.s3"
  route_table_ids = [
    aws_route_table.private.id,
  ]
  vpc_endpoint_type = "Gateway"

  tags = {
    Name = "${var.vpc_name}-s3-endpoint"
  }
}

########## ROUTE TABLES ##########
########## PRIVATE ROUTE TABLE ##########

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.vpc_name}-rt-private"
  }
  depends_on = [
    aws_subnet.private[0],
    aws_subnet.private[1],
    aws_subnet.private[2],
  ]
}

resource "aws_route" "private_nat_gateway" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.main.id
  depends_on = [
    aws_route_table.private,
    aws_nat_gateway.main,
  ]
}

resource "aws_main_route_table_association" "main" {
  route_table_id = aws_route_table.private.id
  vpc_id         = aws_vpc.main.id
}

resource "aws_route_table_association" "private" {
  route_table_id = aws_route_table.private.id
  count          = var.private_subnets_qty
  subnet_id      = aws_subnet.private[count.index].id
}

########## PUBLIC ROUTE TABLE ##########

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.vpc_name}-rt-public"
  }
}

resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
  depends_on = [
    aws_route_table.public,
    aws_internet_gateway.main,
  ]
}

resource "aws_route_table_association" "public" {
  route_table_id = aws_route_table.public.id
  count          = var.public_subnets_qty
  subnet_id      = aws_subnet.public[count.index].id
}