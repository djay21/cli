#!/bin/bash

# Initialization : The script initializes two variables, zone and interface, which define the filters for the network interfaces.
# Conditional Logic : It uses conditional statements to check whether the variables zone and interface are non-empty and applies filtering accordingly.
# AWS CLI Command : Utilizes aws ec2 describe-network-interfaces to fetch data about EC2 network interfaces. The output is formatted using the --query option.
# JSON Processing : Employs jq to process and filter JSON output from the AWS CLI, allowing for more specific data extraction based on the values of zone and interface.
# Output Variants :
# Both filters applied: Interfaces matching both the specified zone and interface type are shown.
# Single filter applied: Interfaces matching either the zone or the interface type are displayed.
# No filters: The complete list of network interfaces is output in table format using --output table

zone="we"
interface="wr"
if [[ ($zone != "" ) && ($interface != "" ) ]];
then 
echo "Found both Zone and Interface Filter"
aws ec2 describe-network-interfaces --query "NetworkInterfaces[].{AvailabilityZone:AvailabilityZone,Description:Description,SG:join(' ',Groups[].GroupName),InterfaceType:InterfaceType,PrivateIpAddress:PrivateIpAddress,SubnetId:SubnetId,InstanceID:Attachment.InstanceId}" | jq '.[] | select((.AvailabilityZone == "'"$zone"'") and (.InterfaceType == "'"$interface"'"))'
elif [[ $interface != "" ]]
then
echo "Found Interface filter"
aws ec2 describe-network-interfaces --query "NetworkInterfaces[].{AvailabilityZone:AvailabilityZone,Description:Description,SG:join(' ',Groups[].GroupName),InterfaceType:InterfaceType,PrivateIpAddress:PrivateIpAddress,SubnetId:SubnetId,InstanceID:Attachment.InstanceId}" | jq '.[] | select(.InterfaceType == "'"$interface"'")'
elif [[ $zone != "" ]]
then 
echo "Found Zone filter"
aws ec2 describe-network-interfaces --query "NetworkInterfaces[].{AvailabilityZone:AvailabilityZone,Description:Description,SG:join(' ',Groups[].GroupName),InterfaceType:InterfaceType,PrivateIpAddress:PrivateIpAddress,SubnetId:SubnetId,InstanceID:Attachment.InstanceId}" | jq '.[] | select(.AvailabilityZone == "'"$zone"'")'
else
echo "No filters"
aws ec2 describe-network-interfaces --query "NetworkInterfaces[].{AvailabilityZone:AvailabilityZone,Description:Description,SG:join(' ',Groups[].GroupName),InterfaceType:InterfaceType,PrivateIpAddress:PrivateIpAddress,SubnetId:SubnetId,InstanceID:Attachment.InstanceId}" --output table 
fi