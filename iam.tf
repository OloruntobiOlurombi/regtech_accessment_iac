# Declare the aws_caller_identity data source
data "aws_caller_identity" "current" {}

# IAM Role  For EC2
# resource "aws_iam_role" "ec2_instance_role" {
#     name = var.ec2_instance_role_name

#     assume_role_policy = jsonencode({
#         Version = "2012-10-17",
#         Statement = [
#             {
#                 Action = "sts:AssumeRole",
#                 Effect = "Allow",
#                 Principal = {
#                     Service = "ec2.amazonaws.com"
#                 }
#             }
#         ]
#     })
# }

# Policies For EC2 IAM Role

# Attach Policies 
# resource "aws_iam_role_policy_attachment" "ec2_full_access" {
#     role = aws_iam_role.ec2_instance_role.name
#     policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
# }

# resource "aws_iam_role_policy_attachment" "ec2_read_only_access" {
#     role = aws_iam_role.ec2_instance_role.name 
#     policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
# }

# Create an Instance Profile (for attaching the role to an EC2 instance)
# resource "aws_iam_instance_profile" "ec2_instance_profile" {
#     name = var.ec2_instance_profile
#     role = aws_iam_role.ec2_instance_role.name
# }

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

# resource "aws_iam_role_policy_attachment" "eks_service_policy_attachment" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
#   role = aws_iam_role.eks_cluster_role.name
# }

resource "aws_iam_role_policy_attachment" "eks_service_policy_attachment" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
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

resource "aws_iam_instance_profile" "eks_node_instance_profile" {
    name = var.eks_node_group_profile
    role = aws_iam_role.eks_node_group_role.name
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

# IAM Role for CloudWatch 

resource "aws_iam_role" "cloudwatch_role" {
  name = "cloudwatch_role_log"

  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": "cloudwatch.amazonaws.com"
        },
        "Effect": "Allow",
        "Sid": ""
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "cloudwatch_policy_attachment" {
  role       = aws_iam_role.cloudwatch_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}

# IAM Role for CloudTrail

resource "aws_iam_role" "cloudtrail_role" {
  name = "cloudtrail_role_log"

  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": "cloudtrail.amazonaws.com"
        },
        "Effect": "Allow",
        "Sid": ""
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "cloudtrail_policy_attachment" {
  role       = aws_iam_role.cloudtrail_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCloudTrail_FullAccess"
}


# IAM Role for AWS Config 

# resource "aws_iam_role" "config_role" {
#   name = "config_role"

#   assume_role_policy = jsonencode({
#     "Version": "2012-10-17",
#     "Statement": [
#       {
#         "Action": "sts:AssumeRole",
#         "Principal": {
#           "Service": "config.amazonaws.com"
#         },
#         "Effect": "Allow",
#         "Sid": ""
#       }
#     ]
#   })
# }

# resource "aws_iam_role_policy_attachment" "config_policy_attachment" {
#   role       = aws_iam_role.config_role.name
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AWSConfigRole"
# }


# KMS Key Policy for Encryption

resource "aws_kms_key" "ebs_encryption_key" {
  description = "KMS key for EBS volume encryption"
}

resource "aws_kms_key" "s3_encryption_key" {
  description = "KMS key for S3 bucket encryption"
}

resource "aws_kms_key" "eks_encryption_key" {
  description = "KMS key for EKS secret encryption"
}


resource "aws_s3_bucket_policy" "regtech_iac_policy" {
  bucket = aws_s3_bucket.regtech_iac.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }
        Action = "s3:GetBucketAcl"
        Resource = "arn:aws:s3:::${aws_s3_bucket.regtech_iac.bucket}"
      },
      {
        Effect = "Allow"
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }
        Action = "s3:PutObject"
        Resource = "arn:aws:s3:::${aws_s3_bucket.regtech_iac.bucket}/AWSLogs/${data.aws_caller_identity.current.account_id}/*"
        Condition = {
          StringEquals = {
            "s3:x-amz-acl" = "bucket-owner-full-control"
          }
        }
      }
    ]
  })
}

# resource "aws_kms_key" "ebs_encryption_key" {
#   description             = "KMS key to encrypt EBS volumes"
#   enable_key_rotation     = true

#   policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Effect": "Allow",
#       "Principal": {
#         "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
#       },
#       "Action": "kms:*",
#       "Resource": "*"
#     }
#   ]
# }
# EOF
# }

# resource "aws_kms_alias" "ebs_key_alias" {
#   name          = "alias/ebs-encryption"
#   target_key_id = aws_kms_key.ebs_encryption_key.key_id
# }



# resource "aws_kms_key" "s3_encryption_key" {
#   description = "KMS key for S3 bucket encryption"

#   policy = jsonencode({
#     "Version": "2012-10-17",
#     "Statement": [
#       {
#         "Effect": "Allow",
#         "Principal": {
#           "AWS": [
#             aws_iam_role.cloudtrail_role.arn,
#             aws_iam_role.cloudwatch_role.arn,
#             aws_iam_role.ec2_role.arn
#           ]
#         },
#         "Action": "kms:*",
#         "Resource": "*"
#       }
#     ]
#   })
# }

# resource "aws_kms_key" "eks_encryption_key" {
#   description             = "KMS key to encrypt EKS secrets"
#   enable_key_rotation     = true

#   policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Effect": "Allow",
#       "Principal": {
#         "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
#       },
#       "Action": "kms:*",
#       "Resource": "*"
#     },
#     {
#       "Effect": "Allow",
#       "Principal": {
#         "Service": "eks.amazonaws.com"
#       },
#       "Action": [
#         "kms:Encrypt",
#         "kms:Decrypt",
#         "kms:ReEncrypt*",
#         "kms:GenerateDataKey*",
#         "kms:DescribeKey"
#       ],
#       "Resource": "*"
#     }
#   ]
# }
# EOF
# }

# resource "aws_kms_alias" "eks_key_alias" {
#   name          = "alias/eks-encryption"
#   target_key_id = aws_kms_key.eks_encryption_key.key_id
# }




