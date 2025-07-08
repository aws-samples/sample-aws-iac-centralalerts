# # IAM Role for EventBridge to SNS
# resource "aws_iam_role" "eventbridge_tosns_role" {
#   count = var.enable_central_cwalarms ? 1 : 0
#   name  = var.central_cwalarms_eventtarget_role

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect = "Allow"
#         Principal = {
#           Service = "events.amazonaws.com"
#         }
#         Action = "sts:AssumeRole"
#       }

#     ]
#   })
# }

# # IAM Policy for the role
# resource "aws_iam_role_policy" "eventbridge_sns_policy" {
#   count = var.enable_central_cwalarms ? 1 : 0
#   name  = "${var.central_cwalarms_eventtarget_role}_policy"
#   role  = aws_iam_role.eventbridge_tosns_role[0].id

#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect = "Allow"
#         Action = [
#           "sns:Publish"
#         ]
#         Resource = [for topic in aws_sns_topic.this : topic.arn]
#         # [
#         #   aws_sns_topic.this[*]
#         #   # aws_sns_topic.sns_topic_org_policy[0].arn,
#         #   # aws_sns_topic.sns_topic_backup_changes[0].arn
#         # ]
#       },
#       {
#         Effect = "Allow"
#         Action = [
#           "kms:Encrypt",
#           "kms:Decrypt",
#           "kms:GenerateDataKey"
#         ]
#         Resource = [
#           "arn:aws:kms:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:key/*"
#         ]
#       }
#     ]
#   })
# }


# IAM Role for EventBridge to SQS
resource "aws_iam_role" "eventbridge_tosqs_role" {
  name = "${var.central_cwalarms_eventtarget_role}_sqs"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "events.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }

    ]
  })
}

# IAM Policy for the role
resource "aws_iam_role_policy" "eventbridge_sqs_policy" {
  name = "${var.central_cwalarms_eventtarget_role}_sqs_policy"
  role = aws_iam_role.eventbridge_tosqs_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "sqs:SendMessage"
        ]
        Resource = [aws_sqs_queue.cwarlams.arn, aws_sqs_queue.central_cwalarm_deadletter_queue.arn]
      },
      {
        Effect = "Allow"
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:GenerateDataKey"
        ]
        Resource = [
          "arn:aws:kms:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:key/*"
        ]
      }
    ]
  })
}


# lambda function which will formate the json event to an readable message
resource "aws_iam_role" "cwalarms_sns_enricher" {
  name = var.sns_enricher_lambda_role

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : "sts:AssumeRole",
        "Principal" : {
          "Service" : "lambda.amazonaws.com"
        },
        "Effect" : "Allow",
        "Sid" : ""
      }
    ]
  })
}

resource "aws_iam_role_policy" "cwalarms_sns_enricher" {
  name = "${var.sns_enricher_lambda_role}_policy"
  role = aws_iam_role.cwalarms_sns_enricher.id

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        "Resource" : [
          "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/${var.sns_enricher_lambda_name}:*"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : "sns:Publish",
        "Resource" : [
          for topic in aws_sns_topic.this : topic.arn
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "sqs:GetQueueAttributes",
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
          "sqs:SendMessage",
          "sqs:ChangeMessageVisibility"
        ],
        "Resource" : [
          aws_sqs_queue.central_cwalarm_deadletter_queue.arn,
          aws_sqs_queue.cwarlams.arn
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "ssm:GetParameters"
        ],
        "Resource" : [
          aws_ssm_parameter.team_notification_map.arn
        ],
      },
      {
        Effect : "Allow",
        Action = [
          "kms:Decrypt",
          "kms:GenerateDataKey*"
        ]
        Resource = aws_kms_key.cwalarms_kms_key.arn
      }
    ]
  })
}
