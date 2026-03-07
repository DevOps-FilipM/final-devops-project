variable "aws_region" {
  description = "AWS region where infrastructure will be deployed"
  type        = string
  default     = "eu-central-1"
}

variable "project_name" {
  description = "Name of the project, used for naming resources"
  type        = string
  default     = "final-devops-project"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "ec2_instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "docker_image" {
  description = "Docker image to deploy on EC2"
  type        = string
  default     = "fmagiera/todo-app:latest"
}

variable "ssh_key_name" {
  description = "Name of the SSH key pair in AWS"
  type        = string
  default     = "devops-key"
}
