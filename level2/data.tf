data "terraform_remote_state" "level1" {
  backend = "s3"

  config = {
    bucket = "terraform-remote-state-733796618401"
    key    = "level1.tfstate"
    region = "us-east-2"
  }
}
