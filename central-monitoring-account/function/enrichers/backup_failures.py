def backupfailure_alters_handler(message_body):
    """Handler for Backup job failures notifications"""
    # Check if the message is nested (event from central alarm system)
    print("In backup handler", message_body)

    message = "Greetings from Central Backup Failures notifier ! \n \n"
    message += "Backup Job State Change alert !!!! \n \n"
    message += "Details:- \n \n"
    message += f"Account:           {message_body['detail']['account']} \n"
    message += f"Region:        {message_body['detail']['region']} \n"

    message += f"Event State:       {message_body['detail']['detail']['state']} \n"
    message += f"Event Message:     {message_body['detail']['detail'].get('statusMessage')} \n"

    resource_name = ""
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

    subject = f"Backup Job Failure Alert ({message_body['detail']['detail']['state']}) {resource_name}"

    return subject, message
