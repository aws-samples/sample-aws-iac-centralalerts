# tflint-ignore: terraform_unused_declarations
data "archive_file" "cwalarms_functions" {
  type        = "zip"
  source_dir  = "./function/"
  output_path = "artifacts/${var.sns_enricher_lambda_name}_functions.zip"
}

resource "aws_lambda_event_source_mapping" "cwalarms_sns_enricher" {
  event_source_arn = aws_sqs_queue.cwarlams.arn
  function_name    = aws_lambda_function.cwalarms_sns_enricher.arn

  # filter_criteria {
  #   filter {
  #     pattern = jsonencode({
  #       body = {
  #         Temperature : [{ numeric : [">", 0, "<=", 100] }]
  #         Location : ["New York"]
  #       }
  #     })
  #   }
  # }

}

################# Code signing steps #################
resource "aws_s3_object" "functions_archive" {

  key                    = "lambda/artifacts/${var.sns_enricher_lambda_name}_functions.zip"
  bucket                 = data.aws_s3_bucket.selected.id
  source                 = "artifacts/${var.sns_enricher_lambda_name}_functions.zip"
  server_side_encryption = "AES256"
}

resource "aws_signer_signing_profile" "cwalarms" {
  count       = var.enable_code_signing ? 1 : 0
  name_prefix = var.code_signing_prefix
  platform_id = "AWSLambda-SHA384-ECDSA"

}

resource "aws_lambda_code_signing_config" "cwalarms" {
  count = var.enable_code_signing ? 1 : 0
  allowed_publishers {
    signing_profile_version_arns = [aws_signer_signing_profile.cwalarms[0].version_arn]
  }
  policies {
    untrusted_artifact_on_deployment = "Enforce"
  }
}

# Signing the function
resource "aws_signer_signing_job" "signing_functions" {
  depends_on = [aws_s3_object.functions_archive]

  count = var.enable_code_signing ? 1 : 0

  profile_name = aws_signer_signing_profile.cwalarms[0].name

  source {
    s3 {
      bucket  = data.aws_s3_bucket.selected.id
      key     = aws_s3_object.functions_archive.key
      version = aws_s3_object.functions_archive.version_id
    }
  }

  destination {
    s3 {
      bucket = data.aws_s3_bucket.selected.id
      prefix = "lambda/signed/artifacts/${var.code_signing_prefix}functions_"
    }
  }
}

################# Code signing steps #################

resource "aws_lambda_function" "cwalarms_sns_enricher" {
  function_name = var.sns_enricher_lambda_name
  description   = "This lambda function is used to enrich the cwalarms sns notification in a readable format"

  s3_bucket = var.enable_code_signing ? data.aws_s3_bucket.selected.id : null
  s3_key    = var.enable_code_signing ? aws_signer_signing_job.signing_functions[0].signed_object[0].s3[0].key : null

  code_signing_config_arn = var.enable_code_signing ? aws_lambda_code_signing_config.cwalarms[0].arn : null

  ## checkov:skip=CKV_AWS_272: "Ensure AWS Lambda function is configured to validate code-signing"
  # checkov:skip=CKV_AWS_116: "These lambda functions are triggered manually and not by events so DLQ is not required"
  # checkov:skip=CKV_AWS_117: "Ensure that AWS Lambda function is configured inside a VPC, This lambda dosent need to configured in a VPC"

  filename         = var.enable_code_signing ? null : "artifacts/${var.sns_enricher_lambda_name}_functions.zip"
  source_code_hash = var.enable_code_signing ? null : (fileexists("artifacts/${var.sns_enricher_lambda_name}_functions.zip") ? filebase64sha256("artifacts/${var.sns_enricher_lambda_name}_functions.zip") : null)
  # # source_code_hash = data.archive_file.netappcifs_functions.output_base64sha256

  handler = "lambda_handler.lambda_handler"
  role    = aws_iam_role.cwalarms_sns_enricher.arn
  runtime = "python3.13"

  logging_config {
    application_log_level = "INFO"
    system_log_level      = "DEBUG"
    log_format            = "JSON"
    log_group             = aws_cloudwatch_log_group.cwalarms_sns_enricher.name
  }

  timeout     = var.timeout
  memory_size = var.memory_size

  reserved_concurrent_executions = var.lambda_concurrent_executions
  tracing_config {
    mode = "Active"
  }

  kms_key_arn = aws_kms_key.cwalarms_kms_key.arn

  environment {
    variables = {
      SSM_PARAMETERSTORE_TEAMMAP = aws_ssm_parameter.team_notification_map.name
    }
  }

  tags = merge(var.tags, {
    Name = var.sns_enricher_lambda_name
  })
}
