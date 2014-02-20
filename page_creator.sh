###############################################
# TWiki Page Generator                        #
###############################################

#Environment Variables

LOCATION=/usr/local/twiki/

#Template Locations (No Leading / )

OPERATIONS=data/Operations/

#Template Names (Just Filename.txt)

OPERATIONS_TEMPLATE=OperationsMeetingTemplate.txt


#Prompt for Options

while true; do
    read -p 	"What page would you like to create?
1 - Operations
2 - Quit
" page

    case $page in
        [1]* ) make install; break;;
        [2]* ) exit;;
        * ) echo "Please answer with a number.";;
    esac
done



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
sudo cp $LOCATION$OPERATIONS$OPERATIONS_TEMPLATE ./$TOPIC.tmp


# Makes changes to date in template file and outputs to final topic.
sudo sed '2i\'"$MEETINGDATE" $TOPIC.tmp > $TOPIC.txt

# Cleans up temporary file
sudo rm $TOPIC.tmp

# Set permissions on topic so that TWiki can edit it.
sudo chown apache:apache $TOPIC.txt

# Moves topic from local user directory to twiki directory
sudo mv $TOPIC.txt $LOCATION$OPERATIONS

# Confirms file that was created.  Not needed if put in crontab.
echo $TOPIC.txt created.


# Creates local temp file of Meeting Minutes list
sudo cp $LOCATION$OPERATIONSProductionMeetingMinutes.txt ./ProductionMeetingMinutes.tmp

# Inserts topic into correct spot in list
sudo sed '17i\'"   * $TOPIC" ProductionMeetingMinutes.tmp > ProductionMeetingMinutes.txt

# Corrects permissions if needed
sudo chown apache:apache ProductionMeetingMinutes.txt

# Places edited file into production
sudo mv ProductionMeetingMinutes.txt $LOCATION$OPERATIONS
