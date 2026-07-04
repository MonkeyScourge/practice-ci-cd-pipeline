#! /bin/bash

set -e
# accepts '<argument>'
# Description: simple script taking arguments
#              and passing them into aws ssm send-command gracefully
# TO BE INVOKED BY GITHUB RUNNER

# - instance id accessed through environment variable created
#	by workflow
# - turns all script arguments into json string array
# - json string array passed into --parameter from ssm send-command

	# processes arguments into json string array
commands_json=$(printf '%s\n' "$@" | jq -R . | jq -s .)

echo "commands: $commands_json"

	# arguments transformed to fit send-command format
        # accesses instance id directly through environment variable
aws ssm send-command \
  --instance-ids "$INSTANCE_ID" \
  --document-name "AWS-RunShellScript" \
  --parameters "{\"commands\": $commands_json}" \
  --region us-west-1


