#!/bin/sh

set -e
#Docker compose location
COMPOSE=/docker/
#log Location
LOGARCHIVE=/docker-data/docker-logarchive/
#Log file name
FILE=update.log

#No users servicable code below
YELLOW="\e[33m"
GREEN="\e[32m"
ENDCOLOR="\e[0m"
DATE=$(date +"%m-%d-%Y")

#Change working folder
cd "$COMPOSE"

if test -f "$FILE"; then
        mv "$FILE" "$LOGARCHIVE""$FILE"-"$DATE"
fi

echo "" >> "$FILE"
echo "${YELLOW}Commencing docker update${ENDCOLOR}" >> "$FILE"

#Pull new images
echo "" >> "$FILE"
echo "${GREEN}Pulling new images `date`${ENDCOLOR}" >> "$FILE"
/usr/bin/docker compose pull >> "$FILE" 2>&1

#Up new images
echo "" >> "$FILE"
echo "${GREEN}Updating Containers `date`${ENDCOLOR}" >> "$FILE"
/usr/local/bin/docker-compose up -d >> "$FILE" 2>&1

#Clear dangling images
echo "" >> "$FILE"
echo "${GREEN}Clearing dangling images `date`${ENDCOLOR}" >> "$FILE"
/usr/bin/docker image prune -a -f >> "$FILE" 2>&1

#Log clean up
echo "" >> "$FILE"
if find "$LOGARCHIVE" -name "*.log" -type f -mtime +30 | grep . ; then
        echo "${YELLOW}Found logs older than 30days ${ENDCOLOR}" >> "$FILE";
        find "$LOGARCHIVE" -name "*.log" -type f -mtime +30     -delete
        echo "${GREEN}Purging excess logs `date`${ENDCOLOR}" >> "$FILE"
        else
        echo "${GREEN}No old logs to remove `date`${ENDCOLOR}" >> "$FILE"
fi

echo "" >> "$FILE"
echo "${YELLOW}Finishing docker update `date`${ENDCOLOR}" >> "$FILE"
