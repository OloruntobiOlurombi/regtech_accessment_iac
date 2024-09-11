resource "aws_cloudwatch_log_group" "eks_log_group" {
  name              = "/aws/eks/cluster-logs-regtech"
  retention_in_days = 30
}

resource "aws_cloudtrail" "security_trail" {
  name                          = "security-trail-log"
  s3_bucket_name                = aws_s3_bucket.regtech_iac.bucket
  include_global_service_events = true
  is_multi_region_trail         = true
  enable_log_file_validation    = true

  event_selector {
    read_write_type           = "All"
    include_management_events = true

    data_resource {
      type = "AWS::S3::Object"
      values = ["arn:aws:s3:::${aws_s3_bucket.regtech_iac.bucket}/"]
    }
  }
}

# resource "aws_config_configuration_recorder" "main" {
#   name     = "config"
#   role_arn = aws_iam_role.config_role.arn
# }

resource "aws_sns_topic" "alarm_topic" {
    name = "high-cpu-alarm-topic"
}

resource "aws_sns_topic_subscription" "alarm_subscription" {
    topic_arn = aws_sns_topic.alarm_topic.arn
    protocol = "email"
    endpoint = "oloruntobiolurombi@gmail.com"
}

resource "aws_cloudwatch_metric_alarm" "cpu_alarm" {
  alarm_name          = "high_cpu_usage"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "70"

  alarm_actions = [
    aws_sns_topic.alarm_topic.arn
  ]

  dimensions = {
    InstanceId = aws_instance.control_plane.id
  }
}

