terraform {
  backend "s3" {
    bucket         = "terraform-remote-state-733796618401"
    key            = "level2.tfstate"
    region         = "us-east-2"
    dynamodb_table = "terraform-remote-state"
  }
}


provider "aws" {
  region = "us-east-2"
}

