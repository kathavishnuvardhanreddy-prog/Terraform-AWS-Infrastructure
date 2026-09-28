variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "ap-south-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "availability_zone" {
  description = "Availability Zone for the public subnet"
  type        = string
  default     = "ap-south-1a"
}

variable "ssh_port" {
  description = "SSH port"
  type        = number
  default     = 22
}

variable "jenkins_port" {
  description = "Jenkins port"
  type        = number
  default     = 8080
}

variable "application_port" {
  description = "Application port"
  type        = number
  default     = 8081
}
