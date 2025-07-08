# Name of region where  Central CloudWatch Alarms notifier resources are deployed
central_cwalarms_region = "eu-west-2"
# Name of the central CloudWatch Alarms EventBridge bus
central_cwalarms_busname = "central_cwalarms_bus"

# IAM role name for EventBridge to SQS target
central_cwalarms_eventtarget_role = "eventbridge_tosqs_role"

# Name of the EventBridge rule for CloudWatch alarms
central_cwalarms_eventbus_rule = "cwalarms_enriched"

# Name of the CloudWatch log group for enriched alarms
central_cwalarms_loggroup_name = "cwalarms_enriched"

# EventBridge rule pattern for filtering events
# Currently configured to match all sources with empty prefix
eventbus_rule_pattern = {
  "detail" : {
    "source" : [{
      "prefix" : ""
    }]
  }
}

# Alias name for the KMS key used for encryption
central_cwalarms_kms_alias = "alias/kms_cwalarms"

# Name of the main SQS queue for CloudWatch alarms
central_cwarlams_sqs_name = "cwalarms_queue"

# Name of the dead-letter queue for failed message processing
central_cwalarm_deadletter_queue_name = "central_cwalarm_deadletter"

# Retention period for CloudWatch log groups in days
log_group_retention_in_days = 365

#################### SNS Enricher Lambda Configuration ###########################

# Flag to enable/disable code signing for Lambda functions
enable_code_signing = false

# S3 bucket name for storing code signing artifacts
code_signing_bucket_name = "your-code-signing-bucket-name"

# Prefix for code signing related resources
code_signing_prefix = "cwalarms_"

# Name of the Lambda function that enriches SNS notifications
sns_enricher_lambda_name = "cwalarms_sns_enricher"

# IAM role name for the SNS enricher Lambda function
sns_enricher_lambda_role = "cwalarms_sns_enricher_role"

# Lambda function timeout in seconds
timeout = 15

# Lambda function memory allocation in MB
memory_size = 128

# Maximum number of concurrent Lambda function executions
lambda_concurrent_executions = 50

# SSM parameter store name containing team mapping data for event filtering
team_map_parameter_name = "/central_cwalarms/team_map_sns_notifications"

# Configuration map for team rules, SNS topics, and event filtering
# Each rule defines:
# - Topic: SNS topic name
# - sns_subscriptions: List of email subscribers
# - Tags: Key-value pairs for filtering events based on resource tags
filter_data = {

  "default" = {
    Topic             = "default-alerts-topic"
    sns_subscriptions = ["user1@example.com", "user2@example.com"]
    Tags = {
      Key   = ["Name"],
      Value = ["default"]
    }
  }
  "team-rule1" = {
    Topic             = "mytopic"
    sns_subscriptions = ["team1-user1@example.com", "team1-user2@example.com"]
    Tags = {
      Key   = ["Namespace", "Name"],
      Value = ["app831test", "app831test_SINGLE_AZ_1"]
    }
  }
  "team-rule2" = {
    Topic             = "mytopic2"
    sns_subscriptions = ["team2-user1@example.com", "team2-user2@example.com"]
    Tags = {
      Key   = ["Namespace", "Name"],
      Value = ["app831test", "app831test_MULTI_AZ_1"]
    }
  }
}

# Resource tags for the infrastructure
tags = {
  "Namespace"       = "app4test"
  "Environment"     = "development"
  "Owner"           = "owner@example.com"
  "Support"         = "support@example.com"
  "CustomerCode"    = "customer01"
  "ApplicationName" = "centralmonitoring"
}
