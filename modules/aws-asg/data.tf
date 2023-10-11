data "terraform_remote_state" "vpc_remote_data" {
  backend = "s3"
  config = {
    bucket  = "terraform-bucket-state-ahrikanna"
    key     = "${var.name}/vpc/terraform.tfstate"
    profile = "terraform_user"
    region  = "ap-northeast-2"
  }
}

data "terraform_remote_state" "app1_remote_data" {
  backend = "s3"
  config = {
    bucket  = "terraform-bucket-state-ahrikanna"
    key     = "${var.name}/app1/terraform.tfstate"
    profile = "terraform_user"
    region  = "ap-northeast-2"
  }
}

data "terraform_remote_state" "rds_remote_data" {
  backend = "s3"
  config = {
    bucket  = "terraform-bucket-state-ahrikanna"
    key     = "${var.name}/rds/terraform.tfstate"
    profile = "terraform_user"
    region  = "ap-northeast-2"
  }
}