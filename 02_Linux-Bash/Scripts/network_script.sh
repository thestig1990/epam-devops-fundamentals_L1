#!/bin/bash

# This part of the script takes user input and displays the list of possible keys

if [ -z "$1" ]
then
   echo "List of possible keys:"
   echo "--all - displays the IP addresses and symbolic names of all hosts in the current subnet" 
   echo "--target - displays a list of open system TCP ports."
   exit 1
fi


# The variable "CidrBlock" is defined via aws cli, so you must have 
# ec2 instances and know the SubnetId of your current subnet.
# If your hosts are not in AWS cloud, you can use the following variable
# with your own cidr block

CidrBlock=`aws ec2 describe-subnets --filter "Name=subnet-id,Values=subnet-05d44b097055b8b87" --query "Subnets[*].CidrBlock" --output text`
# CidrBlock="172.31.16.0/20"    - example #


# This part of the script prints IP addresses and symbolic names 
# of all hosts in the subnet and prints a list of open system TCP ports

case "$1" in

    --all)
    echo "IP addresses and host names of all hosts in the current subnet:"
    nmap -sn -oG "hosts_in_subnet.txt" $CidrBlock
    sed '1d;$d' hosts_in_subnet.txt > temp.txt \
        && cat temp.txt | awk '{print "IP address: "$2 "\tHostname: " $3}'
    rm -f hosts_in_subnet.txt && mv temp.txt hosts_in_subnet.txt
    ;;

    --target)
    echo "List of open system TCP ports:"
    netstat -atln | grep 'LISTEN' | awk '{split($4,a,":"); print a[2] a[4]}' | sort -u
    #---------------------------------------------------------------------#
    # alternative command:
    # netstat -tulpn | grep 'LISTEN' | awk '{print $4}' | awk -F':' '{print $2 $4}' | sort -u
    ;;

esac
