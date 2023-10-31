variable "aws_region" {
  description = "AWS region where the resources will be created"
  default     = "us-east-2"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  default     = "10.0.0.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR block for the private subnet"
  default     = "10.0.1.0/24"
}

variable "public_subnet_availability_zone" {
  description = "Availability zone for the public subnet"
  default     = "us-east-2a"
}

variable "private_subnet_availability_zone" {
  description = "Availability zone for the private subnet"
  default     = "us-east-2b"
}

variable "docker_registry_ingress_port" {
  description = "Port for Docker registry ingress"
  default     = 5000
}

variable "docker_registry_ami" {
  description = "AMI for the Docker registry EC2 instance"
  default     = "ami-083ac598d805fbb10" # for ubuntu 20

}

variable "docker_registry_instance_type" {
  description = "EC2 instance type for the Docker registry"
  default     = "t2.micro"
}

# EKS Cluster Name
variable "eks_cluster_name" {
  description = "The name of the EKS cluster."
  type        = string
  default     = "python-eks-cluster" # You can change this to your desired cluster name
}


# EKS Node Group Settings
variable "eks_node_group_name" {
  description = "The name of the EKS node group."
  type        = string
  default     = "pythonapp-node-group" # You can change this to your desired node group name
}


#variable "eks_node_instance_type" {
#  description = "The EC2 instance type for EKS worker nodes."
 # type        = string
 # default     = "t2.micro" # Modify as needed
#}

variable "eks_node_desired_size" {
  description = "The desired number of worker nodes in the EKS node group."
  type        = number
  default     = 1
}

variable "eks_node_max_size" {
  description = "The maximum number of worker nodes in the EKS node group."
  type        = number
  default     = 2
}

variable "eks_node_min_size" {
  description = "The minimum number of worker nodes in the EKS node group."
  type        = number
  default     = 1
}


#variable "aws_eks_cluster_auth" {
#description = "eks cluster authentification "  
#type        =   string
#default     =  

#}




#variable "docker_registry_user_data" {
#  description = "User data script for setting up the Docker registry"
#  default = <<-EOF
#              #!/bin/bash
#              # Your user data script here for setting up the Docker registry
#              EOF
#}

variable "aws_subnet_private_subnet_docker_id" {
description = "ID of the private subnet used for Docker in the VPC."
  type        = string
  default     = "subnet-0747b57d1d6a387c6"
}

variable "aws_subnet_public_subnet_docker_id" {
description = "ID of the public subnet used for Docker in the VPC."
  type        = string
  default     = "subnet-05a4cbfe9097176e1"
}
