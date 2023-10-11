data "terraform_remote_state" "vpc_remote_data" {
  backend = "s3"
  config = {
    bucket  = "myterraform-bucket-state-ahrikanna"
    key     = "{var.name}/asg/terraform.tfstate"
    profile = "terraform_user"
    region  = "ap-northeast-2"
  }
}