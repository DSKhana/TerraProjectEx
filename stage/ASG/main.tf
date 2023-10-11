terraform {
  backend "s3" {
    key            = "stage/asg/terraform.tfstate" // 상태파일 저장 경로
    bucket         = "terraform-bucket-state-ahrikanna"
    region         = "ap-northeast-2"
    profile        = "terraform_user"
    dynamodb_table = "terraform-bucket-lock-ahrikanna"
    encrypt        = true
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region  = "ap-northeast-2"
  profile = "terraform_user"
}

module "stage_asg" {
  source           = "../../modules/aws-asg"
  instance_type    = "t2.micro"
  min_size         = "1"
  max_size         = "1"
  name             = "stage"
  private_subnets  = data.terraform_remote_state.vpc_remote_data.outputs.public_subnets
  SSH_SG_ID        = data.terraform_remote_state.vpc_remote_data.outputs.SSH_SG
  HTTP_HTTPS_SG_ID = data.terraform_remote_state.vpc_remote_data.outputs.HTTP_HTTPS_SG
}