data "aws_availability_zones" "available" {
  state = "available"
}
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name               = "${var.env_code}-vpc"
  cidr               = var.vpc_cidr
  azs                = data.aws_availability_zones.available.names[*]
  private_subnets    = var.private_cidr
  public_subnets     = var.public_cidr
  enable_nat_gateway = true
}
