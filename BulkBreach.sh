#!/bin/bash

RED='\033[0;31m'
GREEN='\033[1m'
BLUE='\033[1;36m'
NC='\033[0m'

HELP='USAGE:
Required parameters:
    -e  FILE    Email list file location
    
Optional parameters:
    -o  DIR     Output directory to save the password list
  
Additional parameters:
    -h          Print this help menu
    
Examples:
    Process all emails and export in the same directory as this script
        ./BulkBreach.sh -e /path/to/email_list.txt
    Process all emails and export in a user specified directory
        ./BulkBreach.sh -e /path/to/email_list.txt -o /path/to/output/directory
'

if [[ $# -lt 2 || $# -gt 4 ]]; then
    echo "$HELP"
    exit 2
fi

emailList=""
outputPath=""

POSITIONAL=()
while [[ $# -gt 0 ]]
do
    key="$1"

    case $key in
        -e|--email)
            emailList=$2
            shift # past argument
            shift # past value
        ;;
        -o|--output)
            outputPath=$2
            shift # past argument
            shift # past value
        ;;
        *)    # unknown option
            echo "$HELP"
            exit 2
        ;;
    esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters

if [[ $outputPath == "" ]]; then
    outputPath="$(dirname "${BASH_SOURCE[0]}")"
    outputPath="$(realpath "${outputPath}")"
fi

if [[ -f "$outputPath/BulkBreach_Passwords.txt" ]]; then
    while true; do
        read -p "Existing password file found. Do you wish to override it? (y/n) " yn
        case $yn in
            [Yy]* ) break;;
            [Nn]* ) echo "Exiting..."; exit 0;;
            * ) echo "Please answer y (Yes) or n (No).";;
        esac
    done
fi

echo -e "${BLUE}----- Starting search! -----${NC}\n"

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

sed -i -E '/Collection|dropbox\.com/d' "$outputPath/BulkBreach_Passwords.txt"

sort -u "$outputPath/BulkBreach_Passwords.txt" -o "$outputPath/BulkBreach_Passwords.txt"

passwordCounter=$(wc -l < $outputPath/BulkBreach_Passwords.txt)

echo -e "\n${BLUE}Found $breachedEmailCounter breached emails with $passwordCounter passwords in total!${NC}"

echo -e "${BLUE}----- Finished! -----${NC}" 
