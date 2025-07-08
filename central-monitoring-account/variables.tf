variable "central_cwalarms_region" {
  description = "Central CloudWatch Alarms - Region"
  type        = string
}
variable "central_cwalarms_busname" {
  description = "Central CloudWatch Alarms - Event Bus Name"
  default     = "central-bus"
  type        = string
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "central_cwalarms_kms_alias" {
  description = "Central CloudWatch Alarms - SNS KMS Alias"
  type        = string
}

variable "filter_data" {
  description = "Event pipe Filter Data"
  type = map(object({
    # PipeState         = string
    # Pattern           = any
    Topic             = string
    sns_subscriptions = list(string)
    Tags = object({
      Key   = list(string)
      Value = list(string)
    })
  }))
  default = {}
}

variable "eventbus_rule_pattern" {
  description = "Event pipe Filter Data"
  type        = any
  default     = {}
}


variable "central_cwalarms_eventbus_rule" {
  description = "Central CloudWatch Alarms - Event Bus Rule Name"
  type        = string
}

variable "central_cwalarms_loggroup_name" {
  description = "Central CloudWatch Alarms - Log Group Name"
  type        = string
}

variable "central_cwalarms_eventtarget_role" {
  description = "KMS Key for encrypting cwalarms  log groups, sns topics , lambdas etc"
  type        = string
}

variable "central_cwarlams_sqs_name" {
  description = "Central CloudWatch Alarms - SQS Name"
  type        = string
}

variable "sns_enricher_lambda_name" {
  description = "SNS Enricher Lambda Name"
  type        = string
}

variable "log_group_retention_in_days" {
  description = "Log Group Retention in Days"
  type        = number
}

variable "central_cwalarm_deadletter_queue_name" {
  description = "Central CloudWatch Alarms - Dead Letter Queue Name"
  type        = string
}

variable "team_map_parameter_name" {
  description = "Team Map Parameter Name"
  type        = string
}

variable "enable_code_signing" {
  description = "Enable Code Signing"
  type        = bool
  default     = false
}

variable "code_signing_bucket_name" {
  description = "Code Signing Bucket Name"
  type        = string
}

variable "code_signing_prefix" {
  description = "Code Signing Prefix"
  type        = string
}

variable "sns_enricher_lambda_role" {
  description = "SNS Enricher Lambda Role Name"
  type        = string
}

variable "timeout" {
  description = "SNS Enricher Lambda Timeout"
  type        = number
}

variable "memory_size" {
  description = "SNS Enricher Lambda Memory Size"
  type        = number
}

variable "lambda_concurrent_executions" {
  description = "SNS Enricher Lambda Concurrent Executions"
  type        = number
}
