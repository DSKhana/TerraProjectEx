data "terraform_remote_state" "vpc_remote_data" {
  backend = "s3"
  config = {
    key     = "stage/vpc/terraform.tfstate" // 상태파일 저장 경로
    bucket  = "terraform-bucket-state-ahrikanna"
    region  = "ap-northeast-2"
    profile = "terraform_user"
  }
}