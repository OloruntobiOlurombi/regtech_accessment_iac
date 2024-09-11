variable "region" {
    type = string 
    default = "us-east-1"
}

#variable "profile" {
#  type = string
#  default = "tobi"
#}

variable "bucket_name" {
    type = string 
    default = "terraform-state-bucket-tobi"
}

variable "aws_access_key_id" {
    type = string
    default = ""
}

variable "aws_secret_access_key" {
    type = string
    default = ""
}

variable "tags_vpc" {
    type = string 
    default = "main-vpc-eks"
}

variable "tags_public_rt" {
    type = string 
    default = "public-route-table"
}

variable "tags_igw" {
    type = string 
    default = "internet-gateway"
}

variable "tags_public_subnet_1" {
    type = string 
    default = "public-subnet-1"
}

variable "tags_public_subnet_2" {
    type = string 
    default = "public-subnet-2"
}

variable "tags_public_subnet_3" {
    type = string 
    default = "public-subnet-3"
}

variable "tags_private_subnet_1" {
    type = string 
    default = "private-subnet-1"
}

variable "tags_private_subnet_2" {
    type = string 
    default = "private-subnet-2"
}

variable "tags_private_subnet_3" {
    type = string 
    default = "private-subnet-3"
}

variable "tags_main_sg_eks" {
    type = string
    default = "main-sg-eks"
}

variable "instance_type" {
    type = string 
    default = "t2.micro"
}

variable "cluster_name" {
    type = string 
    default = "EKSCluster"
}

variable "node_group_name" {
    type = string 
    default = "SlaveNode"
}

variable "vpc_cidr_block" {
    type = string 
    default = "10.0.0.0/16"
}

variable "p_s_1_cidr_block" {
    type = string 
    default = "10.0.1.0/24"
}

variable "az_a" {
    type = string 
    default = "us-east-1a"
}

variable "p_s_2_cidr_block" {
    type = string 
    default = "10.0.2.0/24"
}

variable "az_b" {
    type = string 
    default = "us-east-1b"
}

variable "p_s_3_cidr_block" {
    type = string 
    default = "10.0.3.0/24"
}

variable "az_c" {
    type = string 
    default = "us-east-1c"
}

variable "private_s_1_cidr_block" {
    type = string 
    default = "10.0.4.0/24"
}

variable "az_private_a" {
    type = string 
    default = "us-east-1c"
}

variable "private_s_2_cidr_block" {
    type = string 
    default = "10.0.5.0/24"
}

variable "az_private_b" {
    type = string 
    default = "us-east-1c"
}

variable "private_s_3_cidr_block" {
    type = string 
    default = "10.0.6.0/24"
}

variable "az_private_c" {
    type = string 
    default = "us-east-1c"
}

variable "main_sg_description" {
    type = string 
    default = "Allow TLS inbound traffic and all outbound traffic"
}

variable "ec2_instance_role_name" {
    type = string 
    default = "ec2-instance-role"
}

variable "ec2_instance_profile" {
    type = string 
    default = "ec2-instance-profile"
}

variable "eks_cluster_role_name" {
    type = string 
    default = "eksclusterrole-2"
}

variable "eks_node_group_role_name" {
    type = string 
    default = "eks-node-group-role"
}

variable "eks_describe_cluster_policy_name" {
    type = string 
    default = "eks-describe-cluster-policy"
}