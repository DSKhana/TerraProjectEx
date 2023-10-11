variable "instance_type" {
  description = "instance_type"
  type        = string
}

variable "name" {
  description = "asg name"
  type        = string
}

variable "SSH_SG_ID" {
  description = "sg for ssh"
  type        = string
}

variable "HTTP_HTTPS_SG_ID" {
  description = "sg for http and https"
  type        = string
}

variable "desired_capacity" {
  description = "asg_desired_capacity"
  type        = string
}

variable "min_size" {
  description = "asg_min_size"
  type        = number
}

variable "max_size" {
  description = "asg_max_size"
  type        = number
}

variable "private_subnets" {
  description = "private_subents"
  type        = string
}