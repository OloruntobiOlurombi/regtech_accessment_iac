terraform {
  backend "s3" {
    bucket = "terraform-state-bucket-tobi"
    key = "terraform.tfstate"
    region = "us-east-1"
    encrypt = true 
    #profile = "tobi"
  }
}

# Provides an EC2 instance resource

data "aws_ami" "amazon-linux-2" {
 most_recent = true


 filter {
   name   = "owner-alias"
   values = ["amazon"]
 }


 filter {
   name   = "name"
   values = ["amzn2-ami-hvm*"]
 }
}

# Provides a EC2 Instance for Control plane

resource "aws_instance" "control_plane" {
 depends_on = ["aws_internet_gateway.igw"]

 ami                         = "${data.aws_ami.amazon-linux-2.id}"
 instance_type               = var.instance_type
 associate_public_ip_address = true
 iam_instance_profile        = aws_iam_instance_profile.ec2_instance_profile.name
 key_name                    = "bastion"
 vpc_security_group_ids      = ["${aws_security_group.main_sg.id}"]
 subnet_id                   = "${aws_subnet.public_subnet_1.id}"
}

# Provides an EKS Cluster
resource "aws_eks_cluster" "eks_cluster" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_cluster_role.arn

  version = "1.28"

  vpc_config {
    subnet_ids = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id, aws_subnet.public_subnet_3.id]
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy_attachment,
    aws_iam_role_policy_attachment.eks_service_policy_attachment,
  ]
}

# Provides an EKS Node Group 

resource "aws_eks_node_group" "eks_node_group" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = var.node_group_name
  node_role_arn   = aws_iam_role.eks_node_group_role.arn
  subnet_ids      = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id, aws_subnet.public_subnet_3.id]

  scaling_config {
    desired_size = 2
    max_size     = 2
    min_size     = 2
  }

  update_config {
    max_unavailable = 1
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.eks_worker_node_policy_attachment,
    aws_iam_role_policy_attachment.eks_cni_policy_attachment,
    aws_iam_role_policy_attachment.ec2_container_registry_readonly,
  ]
}

# OutPut Resources
output "endpoint" {
  value = aws_eks_cluster.eks_cluster.endpoint
}

output "ec2_public_ip" {
    value = aws_instance.control_plane.public_ip 
}

output "ec2_instance_id" {
    value = aws_instance.control_plane.id
}

output "eks_cluster_name" {
    value = aws_eks_cluster.eks_cluster.name
}