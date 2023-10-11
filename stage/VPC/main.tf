terraform {
  backend "s3" {
    key            = "stage/vpc/terraform.tfstate" // 상태파일 저장 경로
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

/* 
module "SSH_Security_group" {
  source          = "github.com/DSKhana/Terraform_Project_SG"
  name            = "SSH_SG"
  description     = "SSH Port Open"
  vpc_id          = module.stage_vpc.vpc_id
  use_name_prefix = "false"

  ingress_with_cidr_blocks = [
    {
      from_port   = local.ssh_port
      to_port     = local.ssh_port
      protocol    = local.tcp_protocol
      description = "SSH Port"
      cidr_blocks = "10.10.0.0/16"
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

module "HTTP_HTTPS_SG" {
  source          = "github.com/DSKhana/Terraform_Project_SG"
  name            = "HTTP_HTTPS_SG"
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
} */