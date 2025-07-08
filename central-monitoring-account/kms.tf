
resource "aws_kms_key" "cwalarms_kms_key" {
  enable_key_rotation = true
  description         = "KMS Key for encrypting cwalarms  log groups, sns topics , lambdas etc"
  policy = jsonencode({
    "Id" : "member-SNS-kms",
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "Allow access for Key Administrators",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : local.kms_administrator_arn
        },
        "Action" : [
          "kms:Create*",
          "kms:Describe*",
          "kms:Enable*",
          "kms:List*",
          "kms:Put*",
          "kms:Update*",
          "kms:Revoke*",
          "kms:Disable*",
          "kms:Get*",
          "kms:Delete*",
          "kms:TagResource",
          "kms:UntagResource",
          "kms:ScheduleKeyDeletion",
          "kms:CancelKeyDeletion",
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey"
        ],
        "Resource" : "*"
      },
      {
        "Sid" : "Allow CloudWatch Logs to use the key",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "logs.amazonaws.com"
        },
        "Action" : [
          "kms:Encrypt*",
          "kms:Decrypt*",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:Describe*"
        ],
        "Resource" : "*"
      },
      {
        "Sid" : "Allow events to use the key",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "events.amazonaws.com"
        },
        "Action" : [
          "kms:Encrypt*",
          "kms:Decrypt*",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:Describe*"
        ],
        "Resource" : "*"
      },
      {
        "Sid" : "Allow sqs to use the key",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "sqs.amazonaws.com"
        },
        "Action" : [
          "kms:Encrypt*",
          "kms:Decrypt*",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:Describe*"
        ],
        "Resource" : "*"
      }
    ]
  })
}

resource "aws_kms_alias" "cwalarms_kms_alias" {
  name          = var.central_cwalarms_kms_alias
  target_key_id = aws_kms_key.cwalarms_kms_key.key_id
}
