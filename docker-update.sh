#!/bin/sh

set -e
#Choose docker compose location
COMPOSE=/docker/
#Choose log file name and location
FILE=/docker/update.log

#No users servicable code below
YELLOW="\e[33m"
GREEN="\e[32m"
ENDCOLOR="\e[0m"
DATE=$(date +"%m-%d-%Y")

if test -f "$FILE"; then
        mv "$FILE" "$FILE"-"$DATE"
fi

#Change working folder
cd "$COMPOSE"

echo "" >> "$FILE"
echo "${YELLOW}Commencing docker update${ENDCOLOR}" >> "$FILE"

echo "" >> "$FILE"
echo "${GREEN}Pulling new images `date`${ENDCOLOR}" >> "$FILE"
/usr/bin/docker compose pull >> "$FILE" 2>&1

echo "" >> "$FILE"
echo "${GREEN}Updating Containers `date`${ENDCOLOR}" >> "$FILE"
/usr/local/bin/docker-compose up -d >> "$FILE" 2>&1

echo "" >> "$FILE"
echo "${GREEN}Clearing dangling images `date`${ENDCOLOR}" >> "$FILE"
/usr/bin/docker image prune -a -f >> "$FILE" 2>&1

echo "" >> "$FILE"
echo "${YELLOW}Finishing docker update `date`${ENDCOLOR}" >> "$FILE"
