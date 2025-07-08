locals {
  kms_administrator_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
  sns_subscriptions = merge([for tk, tdata in var.filter_data : {
    for subscription in tdata.sns_subscriptions :
    "${tk}-${subscription}" => {
      subscription = subscription
      rule         = tk
      topic        = tdata.Topic
    }
    }
  ]...)

}
