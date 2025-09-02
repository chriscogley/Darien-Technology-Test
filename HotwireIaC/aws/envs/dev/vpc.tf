module "fng-dev-vpc" {
  source              = "../../modules/vpc/vpc"
  vpc_name            = var.vpc_name
  vpc_block           = var.vpc_block
  vpc_flow_log_name   = var.vpc_flow_log_name
  subnet_netmask      = var.vpc_subnet_netmask
  subnet_qty          = var.vpc_subnet_qty
  public_subnets_qty  = var.vpc_public_subnets_qty
  private_subnets_qty = var.vpc_private_subnets_qty
}

resource "aws_vpc_endpoint" "fng-dev-endpoint-ssm" {
  service_name      = "com.amazonaws.us-east-1.ssm"
  vpc_id            = module.fng-dev-vpc.id
  subnet_ids        = [module.fng-dev-vpc.private_subnet[0], module.fng-dev-vpc.public_subnet[1]]
  vpc_endpoint_type = "Interface"
  tags = {
    Name = "fng-dev-endpoint-ssm"
  }
}

resource "aws_vpc_endpoint" "fng-dev-endpoint-ssmmessages" {
  service_name      = "com.amazonaws.us-east-1.ssmmessages"
  vpc_id            = module.fng-dev-vpc.id
  subnet_ids        = [module.fng-dev-vpc.private_subnet[0], module.fng-dev-vpc.public_subnet[1]]
  vpc_endpoint_type = "Interface"
  tags = {
    Name = "fng-dev-endpoint-ssmmessages"
  }
}

resource "aws_vpc_endpoint" "fng-dev-endpoint-ec2messages" {
  service_name      = "com.amazonaws.us-east-1.ec2messages"
  vpc_id            = module.fng-dev-vpc.id
  subnet_ids        = [module.fng-dev-vpc.private_subnet[0], module.fng-dev-vpc.public_subnet[1]]
  vpc_endpoint_type = "Interface"
  tags = {
    Name = "fng-dev-endpoint-ec2messages"
  }
}

resource "aws_vpc_endpoint" "fng-dev-endpoint-s3" {
  service_name      = "com.amazonaws.us-east-1.s3"
  vpc_id            = module.fng-dev-vpc.id
  subnet_ids        = [module.fng-dev-vpc.private_subnet[0], module.fng-dev-vpc.public_subnet[1]]
  vpc_endpoint_type = "Interface"
  tags = {
    Name = "fng-dev-endpoint-s3"
  }
}