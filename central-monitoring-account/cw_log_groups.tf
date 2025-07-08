resource "aws_cloudwatch_log_group" "event_rule" {
  name              = "/aws/events/${var.central_cwalarms_loggroup_name}"
  kms_key_id        = aws_kms_key.cwalarms_kms_key.arn
  retention_in_days = var.log_group_retention_in_days
}

resource "aws_cloudwatch_log_group" "cwalarms_sns_enricher" {
  name              = "/aws/lambda/${var.sns_enricher_lambda_name}"
  kms_key_id        = aws_kms_key.cwalarms_kms_key.arn
  retention_in_days = var.log_group_retention_in_days
}
