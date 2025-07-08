resource "aws_cloudwatch_event_bus" "central_cloudwatch_alarms" {
  name               = var.central_cwalarms_busname
  kms_key_identifier = aws_kms_key.cwalarms_kms_key.arn
  tags = merge(var.tags, {
    Name = var.central_cwalarms_busname
  })
}

data "aws_iam_policy_document" "central_bus_policy" {
  statement {
    sid    = "AllowAllAccountsFromOrganizationToPutEvents"
    effect = "Allow"
    actions = [
      "events:PutEvents"
    ]
    resources = [
      aws_cloudwatch_event_bus.central_cloudwatch_alarms.arn
    ]
    principals {
      type        = "*"
      identifiers = ["*"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:PrincipalOrgID"
      values   = [data.aws_organizations_organization.org.id]
    }
  }
}

resource "aws_cloudwatch_event_bus_policy" "central_bus_policy_attach" {
  policy         = data.aws_iam_policy_document.central_bus_policy.json
  event_bus_name = aws_cloudwatch_event_bus.central_cloudwatch_alarms.name
}


##########################################################################


resource "aws_cloudwatch_event_rule" "cwalarms" {
  name           = var.central_cwalarms_eventbus_rule
  event_bus_name = aws_cloudwatch_event_bus.central_cloudwatch_alarms.arn
  event_pattern  = jsonencode(var.eventbus_rule_pattern)
  tags = merge(var.tags, {
    Name = var.central_cwalarms_eventbus_rule
  })
}

###########################################################################################################

resource "aws_cloudwatch_event_target" "cwalarms_event_sqs_targets" {
  event_bus_name = aws_cloudwatch_event_bus.central_cloudwatch_alarms.arn
  rule           = aws_cloudwatch_event_rule.cwalarms.name

  target_id = "EventToSQS"
  arn       = aws_sqs_queue.cwarlams.arn
  role_arn  = aws_iam_role.eventbridge_tosqs_role.arn

  dead_letter_config {
    arn = aws_sqs_queue.central_cwalarm_deadletter_queue.arn
  }
}

resource "aws_cloudwatch_event_target" "cwalarms_event_logs_targets" {
  event_bus_name = aws_cloudwatch_event_bus.central_cloudwatch_alarms.arn
  rule           = aws_cloudwatch_event_rule.cwalarms.name
  target_id      = "EventToLogGroup"
  arn            = aws_cloudwatch_log_group.event_rule.arn
  dead_letter_config {
    arn = aws_sqs_queue.central_cwalarm_deadletter_queue.arn
  }
}

# resource "aws_cloudwatch_event_target" "cwalarms_event_sns_targets" {
#   for_each = { for idx, datax in var.filter_data : idx => datax if var.enable_central_cwalarms }
#   # count          = var.enable_central_cwalarms ? 1 : 0
#   event_bus_name = aws_cloudwatch_event_bus.central_cloudwatch_alarms[0].arn

#   rule = aws_cloudwatch_event_rule.this[each.key].name

#   target_id = "SNSBackupChanges"
#   arn       = aws_sns_topic.this[each.key].arn
#   role_arn  = aws_iam_role.eventbridge_tosns_role[0].arn

#   dead_letter_config {
#     arn = aws_sqs_queue.central_cwalarm_deadletter_queue[0].arn
#   }
# }
