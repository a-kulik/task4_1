#!/bin/bash
dir_pwd=$(dirname "$0")
dir_pwd=$(cd "$dir_pwd" && pwd)
y=$dir_pwd/task4_1.out
echo "--- Hardware ---" > $y
#----------------//cpuinfo
x=`cat /proc/cpuinfo | grep 'model name' -m 1| cut -d : -f2 |sed 's/^[ \t]*//'`
echo "CPU: $x" >> $y
#---------------//meminfo
x=`cat /proc/meminfo | grep 'MemTotal' | cut -d : -f2 | sed 's/^[ \t]*//' | tr '[:lower:]' '[:upper:]'`
echo "RAM: $x" >> $y
#---------------//Motherboard Product Name
k=`dmidecode -t 2 | grep 'Product Name'| cut -d : -f2 | sed 's/^[ \t]*//'`
if [ -z "$x" ]
then
k="Unknown"
fi
#---------------//Motherboard Manufacturer
x=`dmidecode -t 2 | grep 'Manufacturer'| cut -d : -f2 | sed 's/^[ \t]*//'`
if [ -z "$x" ]
then
x="Unknown"
echo "Motherboard: $x $k" >> $y
else
echo "Motherboard: $x $k" >> $y
fi
#---------------System Serial Number
x=`dmidecode -s system-serial-number`
if [ -z "$x" ]
then
x="Unknown"
echo "System Serial Number: $x" >> $y
else
echo "System Serial Number: $x" >> $y
fi
echo "--- System ---" >> $y
#----------------OS Distribution
x=`cat /etc/os-release | grep 'PRETTY_NAME' | cut -d '"' -f2`
echo "OS Distribution: $x" >> $y
#----------------Kernel version
x=`uname -r`
echo "Kernel version: $x" >> $y
#----------------Installation date

x=`tune2fs -l $(mount | grep -w "on /" | awk '{print $1}') | grep 'Filesystem created:' | awk '{$1=$2=""; print $0}' | sed 's/^ *//'`
echo "Installation date: $x" >> $y
#----------------Hostname
x=`hostname -f 2> /dev/null`
if [ -z "$x" ]
then
x=`hostname -s`
echo "Hostname: $x" >> $y
else
echo "Hostname: $x" >> $y
fi
#----------------Uptime
x=`uptime -p | sed 's/up //'`
echo "Uptime: $x" >> $y
#----------------Processes running
x=`ps -ela --no-headers | wc -l`
echo "Processes running: $x" >> $y
#----------------User logged in
x=`w -h | awk '{print $1}' |wc -l`
echo "User logged in: $x" >> $y

echo "--- Network ---" >> $y
#----------------Network
for i in `ip link | sed '/^ /d'| awk '{print $2}'| cut -d : -f1`
do
x=`ip -o -f inet addr show | awk '{if ($2==R) print $4; else print ""}' R=$i | sed '/^\s*$/d'  `
if (( `echo "$x" | wc -l`>=2 ))
then
echo "$i: $x" | tr '\n' ',' | sed -e 's/,/, /g' |  sed 's/\(.*\), /\1\n/' >> $y
elif [ -z "$x" ]
then
x="-"
echo "$i: $x" >> $y
else
echo "$i: $x" >> $y
fi
done

