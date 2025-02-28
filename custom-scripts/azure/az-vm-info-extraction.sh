### This script automates the extraction and processing of network interface and virtual machine (VM) details from Azure. It gathers information about subnets, virtual machines, and their IP addresses and then organizes and displays this information in a structured manner. The output is written to a file (data.txt), and the data is formatted and displayed using the column command.

#set -aux
az network nic list | jq '.[] | .ipConfigurations[].subnet.id + " " + .virtualMachine.id' | cut -d "/" -f 5,9,11,19 --output-delimiter " # " | tr -d "\"" > vnet_subnet.txt
az vm list-ip-addresses --query "[].virtualMachine.[name,resourceGroup,network.privateIpAddresses,network.publicIpAddresses[].ipAddress]" -o table > ip.txt
rm -rf data.txt
for i in $(cat vnet_subnet.txt | awk -F "#" '{print $4}');
do  
a=$( grep "$i$" vnet_subnet.txt | awk  -F "#" '{print $1}') 
b=$(grep "$i$" vnet_subnet.txt | awk  -F "#" '{print $2}') 
c=$(grep "$i$" vnet_subnet.txt | awk  -F "#" '{print $3}')
d=$(az network vnet subnet show -g $a --vnet-name$b -n $c | jq '.addressPrefix'; )
#echo -e "************************$a\t\t $b\t\t $c\t\t $d**********\n"
#echo $i
e=$(grep "$i" ip.txt | awk  -F " " '{print $3}')
f=$(grep "$i" ip.txt | awk  -F " " '{print $3}')
g=$(grep "$i" ip.txt | awk  -F " " '{print $2}')

#echo "**************$e $f ************"
#echo -e "$a\t\t $b\t\t $c\t\t $d" |awk '{$1 = sprintf("%-30s", $1) 1}' 
echo -e "$g $i $a $b $c $d $e $f\n" >> data.txt

#awk -v a="$a\t\t" -v b="$b\t\t" -v c="$c\t\t" 'BEGIN { printf a,b,c }'

done
column -t data.txt
