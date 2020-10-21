#!/bin/bash

cat $1* | grep $2 | grep $3 |  awk -F" " '{print $1, print $2, print $5, print$6}'
