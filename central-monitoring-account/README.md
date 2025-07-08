# central-monitoring-account

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.8.5 |
| <a name="requirement_archive"></a> [archive](#requirement\_archive) | 2.7.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 5.89 |
| <a name="requirement_time"></a> [time](#requirement\_time) | 0.13.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_archive"></a> [archive](#provider\_archive) | 2.7.0 |
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.89.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_event_bus.central_cloudwatch_alarms](https://registry.terraform.io/providers/hashicorp/aws/5.89/docs/resources/cloudwatch_event_bus) | resource |
| [aws_cloudwatch_event_bus_policy.central_bus_policy_attach](https://registry.terraform.io/providers/hashicorp/aws/5.89/docs/resources/cloudwatch_event_bus_policy) | resource |
| [aws_cloudwatch_event_rule.cwalarms](https://registry.terraform.io/providers/hashicorp/aws/5.89/docs/resources/cloudwatch_event_rule) | resource |
| [aws_cloudwatch_event_target.cwalarms_event_logs_targets](https://registry.terraform.io/providers/hashicorp/aws/5.89/docs/resources/cloudwatch_event_target) | resource |
| [aws_cloudwatch_event_target.cwalarms_event_sqs_targets](https://registry.terraform.io/providers/hashicorp/aws/5.89/docs/resources/cloudwatch_event_target) | resource |
| [aws_cloudwatch_log_group.cwalarms_sns_enricher](https://registry.terraform.io/providers/hashicorp/aws/5.89/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_group.event_rule](https://registry.terraform.io/providers/hashicorp/aws/5.89/docs/resources/cloudwatch_log_group) | resource |
| [aws_iam_role.cwalarms_sns_enricher](https://registry.terraform.io/providers/hashicorp/aws/5.89/docs/resources/iam_role) | resource |
| [aws_iam_role.eventbridge_tosqs_role](https://registry.terraform.io/providers/hashicorp/aws/5.89/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.cwalarms_sns_enricher](https://registry.terraform.io/providers/hashicorp/aws/5.89/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.eventbridge_sqs_policy](https://registry.terraform.io/providers/hashicorp/aws/5.89/docs/resources/iam_role_policy) | resource |
| [aws_kms_alias.cwalarms_kms_alias](https://registry.terraform.io/providers/hashicorp/aws/5.89/docs/resources/kms_alias) | resource |
| [aws_kms_key.cwalarms_kms_key](https://registry.terraform.io/providers/hashicorp/aws/5.89/docs/resources/kms_key) | resource |
| [aws_lambda_code_signing_config.cwalarms](https://registry.terraform.io/providers/hashicorp/aws/5.89/docs/resources/lambda_code_signing_config) | resource |
| [aws_lambda_event_source_mapping.cwalarms_sns_enricher](https://registry.terraform.io/providers/hashicorp/aws/5.89/docs/resources/lambda_event_source_mapping) | resource |
| [aws_lambda_function.cwalarms_sns_enricher](https://registry.terraform.io/providers/hashicorp/aws/5.89/docs/resources/lambda_function) | resource |
| [aws_s3_object.functions_archive](https://registry.terraform.io/providers/hashicorp/aws/5.89/docs/resources/s3_object) | resource |
| [aws_signer_signing_job.signing_functions](https://registry.terraform.io/providers/hashicorp/aws/5.89/docs/resources/signer_signing_job) | resource |
| [aws_signer_signing_profile.cwalarms](https://registry.terraform.io/providers/hashicorp/aws/5.89/docs/resources/signer_signing_profile) | resource |
| [aws_sns_topic.this](https://registry.terraform.io/providers/hashicorp/aws/5.89/docs/resources/sns_topic) | resource |
| [aws_sns_topic_policy.cwalarms_sns_topic_policy](https://registry.terraform.io/providers/hashicorp/aws/5.89/docs/resources/sns_topic_policy) | resource |
| [aws_sns_topic_subscription.cwalarms_sns_subscription](https://registry.terraform.io/providers/hashicorp/aws/5.89/docs/resources/sns_topic_subscription) | resource |
| [aws_sqs_queue.central_cwalarm_deadletter_queue](https://registry.terraform.io/providers/hashicorp/aws/5.89/docs/resources/sqs_queue) | resource |
| [aws_sqs_queue.cwarlams](https://registry.terraform.io/providers/hashicorp/aws/5.89/docs/resources/sqs_queue) | resource |
| [aws_ssm_parameter.team_notification_map](https://registry.terraform.io/providers/hashicorp/aws/5.89/docs/resources/ssm_parameter) | resource |
| [archive_file.cwalarms_functions](https://registry.terraform.io/providers/hashicorp/archive/2.7.0/docs/data-sources/file) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/5.89/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.central_bus_policy](https://registry.terraform.io/providers/hashicorp/aws/5.89/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.sns_topic_policy](https://registry.terraform.io/providers/hashicorp/aws/5.89/docs/data-sources/iam_policy_document) | data source |
| [aws_organizations_organization.org](https://registry.terraform.io/providers/hashicorp/aws/5.89/docs/data-sources/organizations_organization) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/5.89/docs/data-sources/region) | data source |
| [aws_s3_bucket.selected](https://registry.terraform.io/providers/hashicorp/aws/5.89/docs/data-sources/s3_bucket) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_central_cwalarm_deadletter_queue_name"></a> [central\_cwalarm\_deadletter\_queue\_name](#input\_central\_cwalarm\_deadletter\_queue\_name) | Central CloudWatch Alarms - Dead Letter Queue Name | `string` | n/a | yes |
| <a name="input_central_cwalarms_busname"></a> [central\_cwalarms\_busname](#input\_central\_cwalarms\_busname) | Central CloudWatch Alarms - Event Bus Name | `string` | `"central-bus"` | no |
| <a name="input_central_cwalarms_eventbus_rule"></a> [central\_cwalarms\_eventbus\_rule](#input\_central\_cwalarms\_eventbus\_rule) | Central CloudWatch Alarms - Event Bus Rule Name | `string` | n/a | yes |
| <a name="input_central_cwalarms_eventtarget_role"></a> [central\_cwalarms\_eventtarget\_role](#input\_central\_cwalarms\_eventtarget\_role) | KMS Key for encrypting cwalarms  log groups, sns topics , lambdas etc | `string` | n/a | yes |
| <a name="input_central_cwalarms_kms_alias"></a> [central\_cwalarms\_kms\_alias](#input\_central\_cwalarms\_kms\_alias) | Central CloudWatch Alarms - SNS KMS Alias | `string` | n/a | yes |
| <a name="input_central_cwalarms_loggroup_name"></a> [central\_cwalarms\_loggroup\_name](#input\_central\_cwalarms\_loggroup\_name) | Central CloudWatch Alarms - Log Group Name | `string` | n/a | yes |
| <a name="input_central_cwalarms_region"></a> [central\_cwalarms\_region](#input\_central\_cwalarms\_region) | Central CloudWatch Alarms - Region | `string` | n/a | yes |
| <a name="input_central_cwarlams_sqs_name"></a> [central\_cwarlams\_sqs\_name](#input\_central\_cwarlams\_sqs\_name) | Central CloudWatch Alarms - SQS Name | `string` | n/a | yes |
| <a name="input_code_signing_bucket_name"></a> [code\_signing\_bucket\_name](#input\_code\_signing\_bucket\_name) | Code Signing Bucket Name | `string` | n/a | yes |
| <a name="input_code_signing_prefix"></a> [code\_signing\_prefix](#input\_code\_signing\_prefix) | Code Signing Prefix | `string` | n/a | yes |
| <a name="input_enable_code_signing"></a> [enable\_code\_signing](#input\_enable\_code\_signing) | Enable Code Signing | `bool` | `false` | no |
| <a name="input_eventbus_rule_pattern"></a> [eventbus\_rule\_pattern](#input\_eventbus\_rule\_pattern) | Event pipe Filter Data | `any` | `{}` | no |
| <a name="input_filter_data"></a> [filter\_data](#input\_filter\_data) | Event pipe Filter Data | <pre>map(object({<br/>    # PipeState         = string<br/>    # Pattern           = any<br/>    Topic             = string<br/>    sns_subscriptions = list(string)<br/>    Tags = object({<br/>      Key   = list(string)<br/>      Value = list(string)<br/>    })<br/>  }))</pre> | `{}` | no |
| <a name="input_lambda_concurrent_executions"></a> [lambda\_concurrent\_executions](#input\_lambda\_concurrent\_executions) | SNS Enricher Lambda Concurrent Executions | `number` | n/a | yes |
| <a name="input_log_group_retention_in_days"></a> [log\_group\_retention\_in\_days](#input\_log\_group\_retention\_in\_days) | Log Group Retention in Days | `number` | n/a | yes |
| <a name="input_memory_size"></a> [memory\_size](#input\_memory\_size) | SNS Enricher Lambda Memory Size | `number` | n/a | yes |
| <a name="input_sns_enricher_lambda_name"></a> [sns\_enricher\_lambda\_name](#input\_sns\_enricher\_lambda\_name) | SNS Enricher Lambda Name | `string` | n/a | yes |
| <a name="input_sns_enricher_lambda_role"></a> [sns\_enricher\_lambda\_role](#input\_sns\_enricher\_lambda\_role) | SNS Enricher Lambda Role Name | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources | `map(string)` | `{}` | no |
| <a name="input_team_map_parameter_name"></a> [team\_map\_parameter\_name](#input\_team\_map\_parameter\_name) | Team Map Parameter Name | `string` | n/a | yes |
| <a name="input_timeout"></a> [timeout](#input\_timeout) | SNS Enricher Lambda Timeout | `number` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_subscription_map"></a> [subscription\_map](#output\_subscription\_map) | n/a |
<!-- END_TF_DOCS -->
