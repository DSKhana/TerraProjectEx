terraform {
  backend "s3" {
    key            = "stage/alb/terraform.tfstate" // 상태파일 저장 경로
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

module "ALB_Security_group" {
  source          = "terraform-aws-modules/security-group/aws"
  version         = "5.1.0"
  name            = "ALB_SG"
  description     = "HTTP, HTTPS Port Open"
  vpc_id          = module.stage_vpc.vpc_id
  use_name_prefix = "false"

  ingress_with_cidr_blocks = [
    {
      from_port   = local.http_port
      to_port     = local.http_port
      protocol    = local.tcp_protocol
      description = "HTTP Port"
      cidr_blocks = local.all_network
    },
    {
      from_port   = local.https_port
      to_port     = local.https_port
      protocol    = local.tcp_protocol
      description = "HTTPS Port"
      cidr_blocks = local.all_network
    }
  ]
  egress_with_cidr_blocks = [
    {
      from_port   = local.any_port
      to_port     = local.any_port
      protocol    = local.any_protocol
      cidr_blocks = local.all_network
    }
  ]
}

module "stage_alb" {
  source           = "../../modules/aws-alb"
  name             = data.terraform_remote_state.alb_remote_data.outputs.name
  vpc_id           = data.terraform_remote_state.alb_remote_data.outputs.vpc_id
  public_subnets   = data.terraform_remote_state.alb_remote_data.outputs.public_subnets
  HTTP_HTTPS_SG_ID = data.terraform_remote_state.alb_remote_data.outputs.HTTP_HTTPS_SG
}