variable "name" {
  description = "ENV Name (Stage or Pord)"
  type        = string
}

variable "vpc_id" {
  description = "vpc_id"
  type        = string
}

variable "public_subnets" {
  description = "public_subnets"
  type        = list(string)
}

variable "HTTP_HTTPS_SG_ID" {
  description = "HTTP_HTTPS_SG_ID"
  type        = string
}