data "aws_ami" "amazonlinux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

module "asg" {
  source = "../modules/asg"

  env_code             = "finance"
  ami_id               = data.aws_ami.amazonlinux.id
  target_group_arn     = module.lb.target_group_arn
  private_subnet_id    = data.terraform_remote_state.level1.outputs.private_subnet_id
  lb_security_group_id = module.lb.lb_security_group_id
  vpc_id               = data.terraform_remote_state.level1.outputs.vpc_id
}
