#!/bin/bash

INPUT_ARTIFACTS_FOLDER=/hdfs/mentor/calls/archive
function SPARK_JOB {
        echo "Submitting SPARK Job"
}
cd $INPUT_ARTIFACTS_FOLDER
DATA_DAYS=( `find . -name "*.gz"|awk -F "/" '{print $3}'|cut -c 1-13|cut -c 4-11|uniq|sort` )
for DAY in "${DATA_DAYS[@]}"
do :
echo $DAY
HOURS=(`find . -type f -name "*_$DAY??_*" |awk -F "/" '{print $3}'|cut -c 1-2|sort|uniq`)
for HOUR in "${HOURS[@]}"
do :
#echo $HOUR
srchstrTocopy=$(echo -e $HOUR'_'$DAY)
echo $srchstrTocopy
file_cnt=`find . -type f -name "*$srchstrTocopy*"|wc -l`
echo $file_cnt
if [[ -f /tmp/SAUGATA/count.txt ]];
then
                grep "$srchstrTocopy" /tmp/SAUGATA/count.txt 2>/dev/null
                if [[ $? -eq 0 ]];
                then
                        echo "HOUR_DATE Exists!!"
                        cur_cnt=`grep $srchstrTocopy /tmp/SAUGATA/count.txt|awk -F "=" '{print $2}'`
                        if [[ $file_cnt -gt $cur_cnt ]];
                        then
			    SPARK_JOB
			    if [[ $? -eq 0 ]];
			    then
			    	echo "Spark JOB submitted!"
			    	str_srch=$srchstrTocopy"="$cur_cnt
			    	str_repl=$srchstrTocopy"="$file_cnt
			    	sed -i "s/$str_srch/$str_repl/g" /tmp/SAUGATA/count.txt
			    else
			    	echo "SPARK_JOB Failed!"
			    fi
                        else
                        echo "Bye!"
                        fi
                else
                        echo "HOUR_DATE Doesn'tExists!!"
                        echo $srchstrTocopy"="$file_cnt >> /tmp/SAUGATA/count.txt
                        echo $srchstrTocopy"="$file_cnt "at `date "+%Y-%m-%d-%H-%M-%S"`"  >> /tmp/SAUGATA/record.txt
                        SPARK_JOB
                fi
else
        echo "File does not exist"
        echo $srchstrTocopy"="$file_cnt >> /tmp/SAUGATA/count.txt
        echo $srchstrTocopy"="$file_cnt "at `date "+%Y-%m-%d-%H-%M-%S"`"  >> /tmp/SAUGATA/record.txt
        SPARK_JOB
fi
done
done
