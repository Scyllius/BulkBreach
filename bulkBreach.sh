#!/bin/bash

if [[ "$#" -lt 1 && "$#" -gt 2 ]]; then
    echo "Usage: ./bulkBreach.sh <email_list> [output_path]"
    echo "Example: ./bulkBreach.sh /home/user/emails.txt /home/user"
    exit 2
fi

emailList=$(realpath "$1")
outputPath=0

if [[ "$#" -ne 2 ]]; then
    outputPath="$(dirname "${BASH_SOURCE[0]}")"
    outputPath="$(realpath "${outputPath}")"
else outputPath=$2
fi

RED='\033[0;31m'
GREEN='\033[1m'
BLUE='\033[1;36m'
NC='\033[0m'

echo -e "${BLUE}Starting search!${NC}\n"

breachedEmailCounter=0
normalCounter=0
percentage=0
fileLength=$(wc -l < $emailList)

tabs -2

for email in $(cat $emailList); do
    breach=$(h8mail -t $email) 
    
    normalCounter=$(($normalCounter + 1))
    percentage=$(echo "$normalCounter/$fileLength*100" | bc -l)
    
    printf "[%.2f%%]\t" $percentage

    if [[ "$breach" != *"No results founds"* ]]; then
        echo -e "${GREEN}Found breach: $email${NC}" 
        cutBanner=$(echo "$breach" | sed -r "s/[[:cntrl:]]\[[0-9]{1,3}m//g" | sed '0,/^.*_\{90\}/d' | sed '0,/_\{90\}/!d')
        trimOutput=$(echo "$cutBanner" | cut -d '|' -f2 | sed -e 's/^[[:space:]]*//' | sed '/.*_\{30\}/d' | sed '/^\[/d' | sed '/^ *$/d')
        echo "$trimOutput" >> $outputPath/BulkBreach_Passwords.txt
        breachedEmailCounter=$(($breachedEmailCounter + 1))
    else
        echo -e "${RED}Not breached: $email${NC}"
    fi
done

sort -u "$outputPath/BulkBreach_Passwords.txt" -o "$outputPath/BulkBreach_Passwords.txt"

passwordCounter=$(wc -l < $outputPath/BulkBreach_Passwords.txt)

echo -e "\n${BLUE}Found $breachedEmailCounter breached emails with $passwordCounter passwords in total!${NC}"

echo -e "${BLUE}Finished!${NC}" 
