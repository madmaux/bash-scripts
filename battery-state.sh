#!/bin/bash

# Usage: ./batery-state.sh BAT1

current_date=$(date)

ACOLOR='\033[1;31m'
COLORED='\033[1;32m'
NC='\033[0m'
if [ -z "$1" ] || [ $# -eq 0 ]
then
  bat='BAT1'
else
  bat=$1
fi
state=$(upower -i `upower -e|grep "$bat"`|grep state)
time_to_empty=$(upower -i `upower -e|grep "$bat"`|grep "time to empty")
time_to_full=$(upower -i `upower -e|grep "$bat"`|grep "time to full")
percentage=$(upower -i `upower -e|grep "$bat"`|grep percentage)
echo -e ${ACOLOR}${current_date%% }${NC}
echo -e ${COLORED}${percentage%% } 
echo ${state%% } 
echo ${time_to_empty%% } 
echo -e ${time_to_full%% }${NC}
