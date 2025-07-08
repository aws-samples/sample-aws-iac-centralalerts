###########################################################################################################
resource "aws_sns_topic" "this" {
  for_each          = { for idx, datax in var.filter_data : idx => datax }
  display_name      = each.value.Topic
  name              = each.value.Topic
  kms_master_key_id = var.central_cwalarms_kms_alias
  tags = merge(var.tags, {
    Name = each.value.Topic
  })
}

resource "aws_sns_topic_policy" "cwalarms_sns_topic_policy" {
  for_each   = { for idx, datax in var.filter_data : idx => datax }
  depends_on = [aws_sns_topic.this]
  arn        = aws_sns_topic.this[each.key].arn
  policy     = data.aws_iam_policy_document.sns_topic_policy[each.key].json
}


data "aws_iam_policy_document" "sns_topic_policy" {
  for_each   = { for idx, datax in var.filter_data : idx => datax }
  depends_on = [aws_sns_topic.this]

  policy_id = "topic_policy_ID"

  statement {
    actions = [
      "sns:Publish"
    ]
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }

    resources = [
      aws_sns_topic.this[each.key].arn
    ]
    # [for topic in aws_sns_topic.this : topic.arn]
    sid = "topic_statement_ID"
  }
}

resource "aws_sns_topic_subscription" "cwalarms_sns_subscription" {
  depends_on = [aws_sns_topic.this]
  for_each   = { for idx, datax in local.sns_subscriptions : idx => datax }
  topic_arn  = aws_sns_topic.this[each.value.rule].arn
  endpoint   = each.value.subscription
  protocol   = "email"
}
