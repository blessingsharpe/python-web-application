# Provider configuration for AWS
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

}

provider "aws" {
  region = var.aws_region
}

# Create a VPC
resource "aws_vpc" "docker_vpc" {
  cidr_block = var.vpc_cidr
}


#creating internet gateway
resource "aws_internet_gateway" "docker_igw" {
  vpc_id = aws_vpc.docker_vpc.id

}



# Create a public subnet
resource "aws_subnet" "public_subnet_docker" {
  vpc_id                  = aws_vpc.docker_vpc.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = var.public_subnet_availability_zone
  map_public_ip_on_launch = true
}

# Create a private subnet
resource "aws_subnet" "private_subnet_docker" {
  vpc_id            = aws_vpc.docker_vpc.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = var.private_subnet_availability_zone
}

# Create a security group for your Docker registry
resource "aws_security_group" "docker_registry_sg" {
name = "security"
description = "Security group for Docker registry EC2 instance"
vpc_id = aws_vpc.docker_vpc.id

  # Define ingress and egress rules as needed for your use case
  # For example, you might need to open port 5000 for your Docker registry
 ingress {
    from_port   = var.docker_registry_ingress_port
    to_port     = var.docker_registry_ingress_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Open port 22 for SSH (you might want to restrict this for production)
  #ingress {
  # from_port   = 22
  #to_port     = 22
  #protocol    = "tcp"
  #cidr_blocks = ["0.0.0.0/0"]
  #}

  # Define egress rules as needed
  egress {
    from_port   = 0
    to_port     = 0     # Allow all outbound traffic
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]    # Allow traffic to any destination
  }
}

# Create an EC2 instance for your Docker registry
resource "aws_instance" "docker_registry" {
  ami             = var.docker_registry_ami
  instance_type   = var.docker_registry_instance_type
  subnet_id       = aws_subnet.private_subnet_docker.id
  security_groups = [aws_security_group.docker_registry_sg.id]
  

  # You can customize the user data script to set up your Docker registry on launch
  #user_data = var.docker_registry_user_data
}



resource "aws_eks_cluster" "pythonapp_cluster" {
  name     = "python-eks-cluster"
  role_arn = aws_iam_role.eks_cluster_role.arn
  vpc_config {
    subnet_ids = ["subnet-05a4cbfe9097176e1","subnet-0747b57d1d6a387c6"]
  }
  depends_on = [aws_eks_cluster.pythonapp_cluster]
}

resource "aws_eks_node_group" "pythonapp_workers" {
  cluster_name    = aws_eks_cluster.pythonapp_cluster.name
  node_group_name = var.eks_node_group_name
  node_role_arn   = aws_iam_role.eks_nodes_role.arn
  subnet_ids      = ["subnet-05a4cbfe9097176e1","subnet-0747b57d1d6a387c6"]
  instance_types  = ["t2.micro"] # Modify as needed
  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }
}

#Create IAM roles for your EKS cluster and worker nodes
resource "aws_iam_role" "eks_cluster_role" {
  name = "eks-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "eks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role" "eks_nodes_role" {
  name = "eks-nodes-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

#To authenticate with your EKS cluster, create an authentication config using a data block instead of resource block
#resource "aws_eks_cluster_auth" "pythonapp_cluster_auth" {
#  name = aws-eks-auth
#}

data "aws_eks_cluster_auth" "pythonapp_cluster_auth" {
name = "python-eks-cluster"
#region = "us-east-2"

}
