# Declare the aws_caller_identity data source
data "aws_caller_identity" "current" {}

# IAM Role  For EC2
resource "aws_iam_role" "ec2_instance_role" {
    name = var.ec2_instance_role_name

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

# Policies For EC2 IAM Role

# Attach Policies 
resource "aws_iam_role_policy_attachment" "ec2_full_access" {
    role = aws_iam_role.ec2_instance_role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

resource "aws_iam_role_policy_attachment" "ec2_read_only_access" {
    role = aws_iam_role.ec2_instance_role.name 
    policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
}

# Create an Instance Profile (for attaching the role to an EC2 instance)
resource "aws_iam_instance_profile" "ec2_instance_profile" {
    name = var.ec2_instance_profile
    role = aws_iam_role.ec2_instance_role.name
}

# IAM Role for EKS Cluster Plane 

resource "aws_iam_role" "eks_cluster_role" {
    name = var.eks_cluster_role_name

    assume_role_policy = jsonencode({
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Principal": {
                    "Service": "eks.amazonaws.com"
                },
                "Action": "sts:AssumeRole"
            }
        ]
    })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy_attachment" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
    role = aws_iam_role.eks_cluster_role.name 
}

resource "aws_iam_role_policy_attachment" "eks_service_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role = aws_iam_role.eks_cluster_role.name
}


# IAM Role for Worker node

resource "aws_iam_role" "eks_node_group_role" {
    name = var.eks_node_group_role_name

    assume_role_policy = jsonencode({
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Principal": {
                    "Service": "ec2.amazonaws.com"
                },
                "Action": "sts:AssumeRole"
            }
        ]
    })
}

resource "aws_iam_role_policy_attachment" "eks_worker_node_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_node_group_role.name
}

resource "aws_iam_role_policy_attachment" "eks_cni_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_node_group_role.name
}

resource "aws_iam_role_policy_attachment" "ec2_container_registry_readonly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_node_group_role.name
}

# Create a Policy That Allows The eks:DescribeCluster Action

resource "aws_iam_policy" "eks_describe_cluster_policy" {
  name        = var.eks_describe_cluster_policy_name
  description = "Policy to allow describing EKS clusters"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = "eks:DescribeCluster"
        Effect   = "Allow"
        Resource = "arn:aws:eks:${var.region}:${data.aws_caller_identity.current.account_id}:cluster/${var.cluster_name}"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_describe_cluster_policy_attachment" {
  role       = aws_iam_role.ec2_instance_role.name
  policy_arn = aws_iam_policy.eks_describe_cluster_policy.arn
}

