#!/bin/bash
. ~/.bash_profile

#ostype=`uname`
script_dir=`pwd`

#df -h |grep -vE 'mapper|tmpfs|boot'| awk '{ print $5 "-" $1 "-" $2 "-" $3 "-" $4}'|sed 's/\/-/\/root-/g' > /u01/app/oracle/MOUNT_ALARM/MOUNT/mount_pt_alarm_1.out
#echo "-----------------------------------------------" >> /u01/app/oracle/MOUNT_ALARM/MOUNT/mount_pt_alarm_1.out
/u01/app/oracle/MOUNT_ALARM/MOUNT/mount_pt_alarm_1.sh > /u01/app/oracle/MOUNT_ALARM/MOUNT/mount_pt_alarm_1.out
echo -e "`hostname`------- Mount Point Status\n" > /u01/app/oracle/MOUNT_ALARM/MOUNT/mount_pt_alarm_2.out
cat /u01/app/oracle/MOUNT_ALARM/MOUNT/mount_pt_alarm_1.out|grep -v OK >> /u01/app/oracle/MOUNT_ALARM/MOUNT/mount_pt_alarm_2.out
alarm_cnt=`cat /u01/app/oracle/MOUNT_ALARM/MOUNT/mount_pt_alarm_1.out | grep ALARM | wc -l`
alert_cnt=`cat /u01/app/oracle/MOUNT_ALARM/MOUNT/mount_pt_alarm_1.out | grep ALERT | wc -l`
crashed_cnt=`cat /u01/app/oracle/MOUNT_ALARM/MOUNT/mount_pt_alarm_1.out | grep CRASHED | wc -l`

if [[ alarm_cnt > 0 ]] || [[ alert_cnt -gt 0 ]] || [[ crashed_cnt -gt 0 ]]
then
/bin/mailx -s "Mount Point Alarm -- `hostname`" `cat /u01/app/oracle/MOUNT_ALARM/MOUNT/mail_list` < /u01/app/oracle/MOUNT_ALARM/MOUNT/mount_pt_alarm_2.out
fi

rm -rf $script_dir/mount_pt_alarm_1.out
rm -rf $script_dir/mount_pt_alarm_2.out
