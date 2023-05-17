module "lb" {
  source = "../modules/lb"

  env_code         = "finance"  
  vpc_id           = data.terraform_remote_state.level1.outputs.vpc_id
  public_subnet_id = data.terraform_remote_state.level1.outputs.public_subnet_id
}
