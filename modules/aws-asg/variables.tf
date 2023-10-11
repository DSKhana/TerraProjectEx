variable "instance_type" {
  description = "EC2 Instance Type"
  type        = string
}

variable "min_size" {
  description = "ASG Min Size"
  type        = number
}

variable "max_size" {
  description = "ASG Max Size"
  type        = number
}

variable "name" {
  description = "ENV name (Stage or Prod)"
  type        = string
}

variable "private_subnets" {
  description = "Private Subents"
  type        = list(string)
}

variable "SSH_SG_ID" {
  description = "SSH SG ID"
  type        = string
}

variable "HTTP_HTTPS_SG_ID" {
  description = "HTTP HTTPS SG ID"
  type        = string
}