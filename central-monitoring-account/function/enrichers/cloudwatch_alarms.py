def cloudwatch_alarm_handler(message_body):
    """Handler for CloudWatch Alarm notifications"""
    # Check if the message is nested (event from central alarm system)
    if "detail" in message_body and isinstance(message_body["detail"], dict) and "detail" in message_body["detail"]:
        # Use the nested detail
        alarm_detail = message_body["detail"]["detail"]
    else:
        # Use the direct detail
        alarm_detail = message_body["detail"]

    # Extract alarm information
    alarm_state = alarm_detail["state"]["value"]
    alarm_name = alarm_detail["alarmName"]
    alarm_reason = alarm_detail["state"]["reason"]
    resource_name = ""

    # Process metrics
    for metric in alarm_detail["configuration"]["metrics"]:
        if metric.get("label"):
            metric_name = metric["label"]
            metric_stat = metric["expression"]
            break
        elif metric.get("metricStat"):
            metric_name = metric["metricStat"]["metric"]["name"]
            metric_stat = metric["metricStat"]["stat"]
            break

    print(f"Alarm Detail: {alarm_detail}")

    metric_description = alarm_detail["configuration"].get("description")

    message = "Greetings from Central Cloudwatch Alarms notifier ! \n \n"
    message += "Cloudwatch alarms state change alert !!!! \n \n"
    message += "Alarm details:- \n \n"
    message += f"Account:           {message_body['account']} \n"
    message += f"Alarm Name:        {alarm_name} \n"
    message += f"Alarm State:       {alarm_state} \n"
    message += f"Alarm Reason:      {alarm_reason} \n"

    # Check for enriched data in the correct location
    if "enriched" in message_body["detail"]:
        if message_body["detail"]["enriched"].get("monitored_resources"):
            message += f"Monitored Resource:    {message_body['detail']['enriched']['monitored_resources'][0]} \n"

        # Add resource name if available
        for tag in message_body["detail"]["enriched"]["resource_tags"]:
            if tag["Key"] == "Name":
                resource_name = tag["Value"]
                message += f"Resource Name:     {tag['Value']} \n"
                break

    message += "\n \n"
    message += f"Metric Name:       {metric_name} \n"
    message += f"Metric Description:    {metric_description} \n"
    message += f"Metric Stat:       {metric_stat} \n"

    subject = f"CWAlarm ({alarm_state}) {alarm_name}/{resource_name}"

    return subject, message
