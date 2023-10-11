terraform {
  backend "s3" {
    key            = "stage/rds/terraform.tfstate" // 상태파일 저장 경로
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

module "app1_db" {
  source                              = "github.com/DSKhana/terraform-aws-rds"
  identifier                          = "stage-app1-db"
  engine                              = "mysql"
  engine_version                      = "5.7.42"
  instance_class                      = "db.t3.micro"
  allocated_storage                   = 5
  multi_az                            = false
  iam_database_authentication_enabled = true
  manage_master_user_password         = false
  skip_final_snapshot                 = true
  family                              = "mysql5.7"
  parameters = [
    {
      name  = "character_set_client"
      value = "utf8mb4"
    },
    {
      name  = "character_set_server"
      value = "utf8mb4"
    }
  ]

  major_engine_version = "5.7"
  db_name              = "webdb"
  username             = "admin"
  password             = "RDSterraform123!"
  port                 = "3306"

  db_subnet_group_name   = data.terraform_remote_state.vpc_remote_data.outputs.database_subnet_group
  subnet_ids             = data.terraform_remote_state.vpc_remote_data.outputs.database_subnets
  vpc_security_group_ids = [data.terraform_remote_state.vpc_remote_data.outputs.RDS_SG]
}
