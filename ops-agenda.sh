###############################################
# TWiki Operations Meeting Template Generator #
# Written by Kyle Gross                       #
###############################################

#Environment Variables

LOCATION=/usr/local/twiki/

OPERATIONS=/data/Operations

echo $LOCATION
echo $OPERATIONS

#Get the full word Value of today (ie Monday, Tuesday)
TODAY=$(date "+%A" -d today)

# Decide if the operator needs to be next-week or next-monday depending on which day the cron job will run this
# TOPIC will hold the Topic Name such as Minutes2010August02
# MEETINGDATE will be the string to insert into the meeting topic

if [ $TODAY == "Monday" ]; then
        TOPIC=$(echo Minutes`date +%Y%B%d -d this-week`)
        MEETINGDATE=$(echo ---+ Operations Meeting `date "+%B %d, %Y" -d this-week`)

else
    	TOPIC=$(echo Minutes`date +%Y%B%d -d next-monday`)
        MEETINGDATE=$(echo ---+ Operations Meeting `date "+%B %d, %Y" -d next-monday`)
fi

# Uses template file to copy Topic into a temporary file to be edited then put into production
sudo cp /usr/local/twiki/data/Operations/OperationsMeetingTemplate.txt ./$TOPIC.tmp

# Makes changes to date in template file and outputs to final topic.
sudo sed '2i\'"$MEETINGDATE" $TOPIC.tmp > $TOPIC.txt

# Cleans up temporary file
sudo rm $TOPIC.tmp

# Set permissions on topic so that TWiki can edit it.
sudo chown apache:apache $TOPIC.txt

# Moves topic from local user directory to twiki directory
sudo mv $TOPIC.txt /usr/local/twiki/data/Operations/

# Confirms file that was created.  Not needed if put in crontab.
echo $TOPIC.txt created.


# Creates local temp file of Meeting Minutes list
sudo cp /usr/local/twiki/data/Operations/ProductionMeetingMinutes.txt ./ProductionMeetingMinutes.tmp

# Inserts topic into correct spot in list
sudo sed '17i\'"   * $TOPIC" ProductionMeetingMinutes.tmp > ProductionMeetingMinutes.txt

# Corrects permissions if needed
sudo chown apache:apache ProductionMeetingMinutes.txt

# Places edited file into production
sudo mv ProductionMeetingMinutes.txt /usr/local/twiki/data/Operations/
