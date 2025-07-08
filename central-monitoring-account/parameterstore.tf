resource "aws_ssm_parameter" "team_notification_map" {
  # checkov:skip=CKV2_AWS_34: "AWS SSM Parameter should be Encrypted"  - This is meta data for deployment dosent contain secret data
  name        = var.team_map_parameter_name
  type        = "SecureString"
  description = "Map of Slack team ID to team name"
  key_id      = try(aws_kms_key.cwalarms_kms_key.key_id, null)
  tier        = "Standard"
  value       = jsonencode(var.filter_data)
  tags = merge(var.tags, {
    Name = var.team_map_parameter_name
  })
}
