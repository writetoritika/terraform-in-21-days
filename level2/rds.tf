data "aws_secretsmanager_secret" "rds_password" {
  name = "main/rds/password"
}

data "aws_secretsmanager_secret_version" "rds_password" {
  secret_id = data.aws_secretsmanager_secret.rds_password.id
}

locals {
  rds_password = jsondecode(data.aws_secretsmanager_secret_version.rds_password.secret_string)["password"]
}

module "rds_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "${var.env_code}-rds"
  description = "Allow port 3306 TCP inbound to RDS within VPC."
  vpc_id      = data.terraform_remote_state.level1.outputs.vpc_id

  computed_ingress_with_source_security_group_id = [
    {
      rule                     = "mysql-tcp"
      source_security_group_id = module.private_sg.security_group_id
    }
  ]
  number_of_computed_ingress_with_source_security_group_id = 1

  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 65535
      protocol    = "tcp"
      description = "rds-sg-out"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
}

module "rds" {
  source = "terraform-aws-modules/rds/aws"

  identifier             = var.env_code
  allocated_storage      = 20
  storage_type           = "gp2"
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t3.micro"
  port                   = "3306"
  db_name                = "mydb"
  username               = "admin"
  password               = local.rds_password
  create_random_password = false

  skip_final_snapshot = true
  multi_az            = false

  vpc_security_group_ids = [module.rds_sg.security_group_id]

  backup_retention_period = 1
  backup_window           = "09:46-10:16"

  create_db_subnet_group = true
  subnet_ids             = data.terraform_remote_state.level1.outputs.private_subnet_id

  family = "mysql5.7"
  major_engine_version = "5.7"
}
