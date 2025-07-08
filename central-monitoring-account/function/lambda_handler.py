import json
import os
from datetime import datetime

import boto3
from enrichers.backup_failures import backupfailure_alters_handler
from enrichers.cloudwatch_alarms import cloudwatch_alarm_handler
from enrichers.ec2_statechange import ec2_state_change_handler

message = ""

# current region
region = os.environ["AWS_REGION"]
# current account id
account_id = boto3.client("sts").get_caller_identity().get("Account")


def match_user_tags(resource_tags, team_map_sns_notifications):
    matched_tags = []
    for fkey, fvalue in team_map_sns_notifications.items():
        for tki, tkv in enumerate(fvalue["Tags"]["Key"]):
            for tag in resource_tags:
                if tag["Key"] == tkv:
                    if tag["Value"] == fvalue["Tags"]["Value"][tki]:
                        print(
                            "matched a tag pair",
                            {tag["Key"]: fvalue["Tags"]["Value"][tki]},
                        )
                        matched_tags.append({tag["Key"]: fvalue})
                        if len(fvalue["Tags"]["Key"]) == len(matched_tags):
                            print("matched all tags")
                            return fvalue

    return None


def lambda_handler(event, context):
    try:
        # Extract the actual event from SQS message
        print(f"sqs event : {json.dumps(event)}")
        sqs_message = event["Records"][0]
        message_body = json.loads(sqs_message["body"]) if isinstance(sqs_message["body"], str) else sqs_message["body"]
        print(f"message body : {json.dumps(message_body)}")
        if message_body["detail"].get("enriched"):
            resource_tags = message_body["detail"]["enriched"]["resource_tags"]
        event_type = message_body["detail"]["detail-type"]

        # Fetch SSM parameters to find the user's sns topic deatils
        ssm_client = boto3.client("ssm")
        ssm_response = ssm_client.get_parameters(
            Names=[os.environ["SSM_PARAMETERSTORE_TEAMMAP"]],
            WithDecryption=True,
        )

        team_map_sns_notifications = json.loads(ssm_response["Parameters"][0]["Value"])
        print(f"team_map_sns_notifications : {team_map_sns_notifications}")
        default_topic_name = team_map_sns_notifications["default"]["Topic"]

        if event_type == "CloudWatch Alarm State Change":
            subject, message = cloudwatch_alarm_handler(message_body)
            # Match tags and send notification
            team = match_user_tags(resource_tags, team_map_sns_notifications)
            if team:
                sns_topic_arn = f"arn:aws:sns:{region}:{account_id}:{team['Topic']}"
            else:
                message += f"Detail: {json.dumps(message_body['detail']['detail'], indent=2)} \n"
                sns_topic_arn = f"arn:aws:sns:{region}:{account_id}:{default_topic_name}"

        elif event_type == "EC2 Instance State-change Notification":
            subject, message = ec2_state_change_handler(message_body)
            team = match_user_tags(resource_tags, team_map_sns_notifications)
            if team:
                sns_topic_arn = f"arn:aws:sns:{region}:{account_id}:{team['Topic']}"
            else:
                message += f"Detail: {json.dumps(message_body['detail']['detail'], indent=2)} \n"
                sns_topic_arn = f"arn:aws:sns:{region}:{account_id}:{default_topic_name}"

        elif event_type == "Backup Job State Change" or event_type == "Backup Copy Job State Change":
            subject, message = backupfailure_alters_handler(message_body)
            print(f"subject: {subject}")
            team = match_user_tags(resource_tags, team_map_sns_notifications)
            if team:
                sns_topic_arn = f"arn:aws:sns:{region}:{account_id}:{team['Topic']}"
            else:
                message += f"Detail: {json.dumps(message_body['detail']['detail'], indent=2)} \n"
                sns_topic_arn = f"arn:aws:sns:{region}:{account_id}:{default_topic_name}"

        else:
            print(f"Unsupported event type: {event_type}")
            subject = f"{event_type} alert !!!!"
            message = "Greetings from Central Event notifier ! \n \n"
            message += f"{event_type} alert !!!! \n \n"
            message += "Details:- \n \n"
            message += f"Account:           {message_body['detail']['account']} \n"
            message += f"Region:        {message_body['detail']['region']} \n"
            message += f"Source:        {message_body['detail']['source']} \n"
            message += f"Resources {message_body['detail']['resources']} \n"
            message += f"Detail: {json.dumps(message_body['detail']['detail'], indent=2)} \n"
            sns_topic_arn = f"arn:aws:sns:{region}:{account_id}:{default_topic_name}"

        # Add common footer to message
        message += "\n \n"
        message += "Please take appropriate actions. \n \n"
        message += "-- \n"
        message += "Original Event:- \n"
        message += json.dumps(message_body)
        message += "\n \n"
        message += f"Email Generated: {str(datetime.today())}"

        try:
            sns_client = boto3.client("sns")
            resp = sns_client.publish(TargetArn=sns_topic_arn, Message=message, Subject=subject[0:99])
            print("publish sns response", json.dumps(resp))
        except Exception as e:
            print(f"SNS error: {e}")
            raise

        return {"subject": subject[0:100], "body": message}

    except KeyError as e:
        print(f"KeyError: {str(e)}")
        print(f"Message body: {json.dumps(message_body)}")
        return {
            "error": f"Missing required field: {str(e)}",
            "original_event": event,
        }
    except Exception as e:
        print(f"Error: {str(e)}")
        return {
            "error": f"Error processing message: {str(e)}",
            "original_event": event,
        }
