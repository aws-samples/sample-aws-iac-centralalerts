def ec2_state_change_handler(message_body):
    """Handler for EC2 state change notifications"""
    instance_id = message_body["detail"]["detail"]["instance-id"]
    instance_state = message_body["detail"]["detail"]["state"]

    message = "Greetings from EC2 State Change notifier ! \n \n"
    message += "EC2 Instance State Change Alert !!!! \n \n"
    message += "Instance details:- \n \n"
    message += f"Account:           {message_body['account']} \n"
    message += f"Region:            {message_body['detail']['region']} \n"
    message += f"Instance ID:       {instance_id} \n"
    message += f"Current State:     {instance_state} \n"

    instance_name = None
    # Add instance name if available
    if message_body["detail"].get("enriched"):
        for tag in message_body["detail"]["enriched"]["resource_tags"]:
            if tag["Key"] == "Name":
                instance_name = tag["Value"]
                message += f"Instance Name:     {tag['Value']} \n"
                break

    subject = f"EC2 Instance ({instance_state}) {instance_id}/{instance_name}"

    return subject, message
