# BulkBreach [![version](https://img.shields.io/badge/version-1.0-red.svg)](https://semver.org)

BulkBreach is a tool created to automate the process of searching for breached passwords. The only difference between this script and using the built-in bulk reading is the output. This script will give you a compact list of breached passwords and the corresponding email. It incorporates a tool called h8mail which you can find [here](https://github.com/khast3x/h8mail).

### Note
This script has only been tested on Kali Linux 2020.2. 

## Requirements
* h8mail - Has to be installed from sources. PIP3 will not work!
* Bash shell (/bin/bash) - It will not work with a `/bin/sh` shell

## Installation
Clone the repository using `git clone https://github.com/Scyllius/BulkBreach.git`

Change to the cloned directory `cd BulkBreach`

Run the script `./BulkBreach.sh`

## Usage

`$ ./BulkBreach.sh -e <email_list> -o [output_path]`

If the `output_path` is not specified, it will use the same folder in which the script is located.


## Usage examples

`$ ./BulkBreach.sh -e /path/to/EmailList.txt`

`$ ./BulkBreach.sh -e /path/to/EmailList.txt -o /path/to/output/directory`
