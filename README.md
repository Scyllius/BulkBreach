# BulkBreach [![version](https://img.shields.io/badge/version-1.0-red.svg)](https://semver.org)

BulkBreach is a tool created to automate the process of searching for breached passwords. The only difference between this script and using the built-in bulk reading is the output. This script will give you a compact list of breached passwords and the corresponding email. It incorporates a tool called h8mail which you can find [here](https://github.com/khast3x/h8mail).

## Requirements
* h8mail - Has to be installed from sources. PIP3 will not work!

## Installation
Clone the repository using `git clone https://github.com/Scyllius/BulkBreach.git`

Change to the cloned directory `cd BulkBreach`

Run the script `./BulkBreach.sh`

## Usage

```console
$ ./BulkBreach.sh <email_list> [output_path]
```

If the `output_path` is not specified, it will use the same folder in which the script is located.


## Usage examples

`$ ./BulkBreach.sh ~/EmailList.txt`

`$ ./BulkBreach.sh ~/EmailList.txt ~/OutputFolder`
