#!/bin/bash
#Please place corresponding win/loss player files in the same directory to output dealer/player correlation
#
#Please insert:
#date time am/pm
#
cat $1* | head -1 ; cat $1* | grep $2 | grep $3 |  awk -F" " '{print $0}'
