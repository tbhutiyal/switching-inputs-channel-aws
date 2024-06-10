#!/bin/bash

# Set initial values
CHANNEL_ID=6460956
LOG_FILE=./switch_loop.log

# Initialize count and max_count
count=0
max_count=5

echo "Starting switch loop script" > $LOG_FILE

while [ $count -lt $max_count ]; do
    # Increment the counter
    count=$((count + 1))

    # Generate JSON file for input 05
    CREATE_SWITCH_JSON=./createswitch_05.json
    unique_action_name="switch05-$count"
    cat <<EOL > $CREATE_SWITCH_JSON
{
  "ChannelId": "$CHANNEL_ID",
  "Creates": {
    "ScheduleActions": [
      {
        "ScheduleActionStartSettings": {
          "ImmediateModeScheduleActionStartSettings": {}
        },
        "ActionName": "$unique_action_name",
        "ScheduleActionSettings": {
          "InputSwitchSettings": {
            "InputAttachmentNameReference": "test-input-05"
          }
        }
      }
    ]
  }
}
EOL
    echo "Generated create switch JSON for input 05 at $(date) with action name $unique_action_name" >> $LOG_FILE

    # Create switch action for input 05
    echo "Creating switch action for input 05 at $(date) with action name $unique_action_name" >> $LOG_FILE
    aws medialive batch-update-schedule --cli-input-json file://$CREATE_SWITCH_JSON >> $LOG_FILE 2>&1

    # Wait for 5 seconds
    sleep 5

    # Generate JSON file for input 04
    CREATE_SWITCH_JSON=./createswitch_04.json
    unique_action_name="switch04-$count"
    cat <<EOL > $CREATE_SWITCH_JSON
{
  "ChannelId": "$CHANNEL_ID",
  "Creates": {
    "ScheduleActions": [
      {
        "ScheduleActionStartSettings": {
          "ImmediateModeScheduleActionStartSettings": {}
        },
        "ActionName": "$unique_action_name",
        "ScheduleActionSettings": {
          "InputSwitchSettings": {
            "InputAttachmentNameReference": "test-input-04"
          }
        }
      }
    ]
  }
}
EOL
    echo "Generated create switch JSON for input 04 at $(date) with action name $unique_action_name" >> $LOG_FILE

    # Create switch action for input 04
    echo "Creating switch action for input 04 at $(date) with action name $unique_action_name" >> $LOG_FILE
    aws medialive batch-update-schedule --cli-input-json file://$CREATE_SWITCH_JSON >> $LOG_FILE 2>&1

    # Wait for 5 seconds before next iteration
    sleep 5
done

echo "Switch loop completed." >> $LOG_FILE
