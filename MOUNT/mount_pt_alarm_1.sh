#!/bin/bash
. ~/.bash_profile

#for i in `df -h | grep -v dev | grep -v Mounted| awk '{ print $(NF)"--"$(NF-1) }'| sed -e 's/%//'`
for i in `df -h| sed -e 's/ / -/g' | grep '-' |awk '{print $NF " " $(NF-1)}' | sed -e 's/-//g'|sed -e 's/%//g' |sed 's/ /-/g' | sed 's/\/-/\/root-/g'|grep -vE 'mapper|tmpfs|boot|Mounted|shm'`
do
a=`echo $i | awk -F - '{print $NF}'`
if [[ $a > 80 ]] && [[ $a < 90 ]]
then
echo $i "----------  ALARM: Mount Reaching Saturation"
elif [[ $a > 90 ]] && [[ $a < 99 ]]
then
echo -e $i "----------  HIGH ALERT: Mount point all most full"
elif [[ $a = "100" ]]
then
echo -e $i "---------- CRASHED! Mount Point Full"
else
echo -e $i "---------- OK"
fi
done
