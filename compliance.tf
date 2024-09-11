# resource "aws_config_config_rule" "s3_bucket_encryption" {
#   name        = "s3-bucket-encryption-enabled"
#   source {
#     owner             = "AWS"
#     source_identifier = "S3_BUCKET_SERVER_SIDE_ENCRYPTION_ENABLED"
#   }
# }
