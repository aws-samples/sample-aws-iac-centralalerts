resource "aws_sqs_queue" "cwarlams" {
  name = var.central_cwarlams_sqs_name
  # sqs_managed_sse_enabled = true
  kms_master_key_id = aws_kms_key.cwalarms_kms_key.key_id

  tags = merge(var.tags, {
    Name = var.central_cwarlams_sqs_name
  })

}

##########################################################################

resource "aws_sqs_queue" "central_cwalarm_deadletter_queue" {
  name              = var.central_cwalarm_deadletter_queue_name
  kms_master_key_id = var.central_cwalarms_kms_alias

  tags = merge(var.tags, {
    Name = var.central_cwalarm_deadletter_queue_name
  })
}
