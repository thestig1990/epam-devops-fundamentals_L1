#!/bin/bash

# This script parses the file with some info and takes 1 parameters for input:
# $1 - Path to the parsing file

# This part of the script takes user input and displays the list of arguments for input
if [ -z "$1" ]
then
   echo "List of arguments for input:"
   echo "1st arg. - Path to the parsing file"
   exit 1
fi

# Arguments Passed
PARS_FILE="$1"

# 1. From which ip were the most requests?
cat $PARS_FILE | awk '{print $1}' | sort | uniq -c | sort -nr -k1 | head -n1 |
 awk '{print "1.The most requests - " $1 " were from IP - " $2}'


# 2. What is the most requested page?
cat $PARS_FILE | awk '{print $11}' | sort | uniq -c | sort -nr | head -n2 | tail -n1 |
 awk '{print "2.The most requested - " $1 " page is - " $2}'

# 3. How many requests were there from each ip? (output only first 10 IP's)
echo "3.How many requests were there from each ip?"
cat $PARS_FILE | awk '{print $1}' | sort | uniq -c | sort -nr -k1 | head |
 awk '{print "\t" $1 " requests from IP - " $2}'

# 4. What non-existent pages were clients referred to? (code 404)
echo "4.What non-existent pages were clients referred to?"
cat $PARS_FILE | awk '$9 == 404 {print $9 "\t" $11}' | sort -n | uniq |
 awk '{print "\t code " $1 " from URL - " $2}'

# 5. What time did site get the most requests?
echo "5.What time did site get the most requests?"
cat $PARS_FILE | awk -F':' '{print $2 ":" $3}' | uniq -c | sort -nr | head -n1 |
 awk '{print "\t The most requests - " $1 " were received at - " $2 " a.m."}'

# 6. What search bots have accessed the site? (UA + IP)
echo "6.What search bots have accessed the site?"
cat $PARS_FILE | awk '{print $1 "\t" $12 $14 $15}' | sed -n /bot/p | sort | uniq |
 awk '{print "\t IP - " $1 " Bots - " $2}'
