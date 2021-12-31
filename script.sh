#!bin/bash
USER=$(whoami)
DATE=$(date +"%d-%m-%Y")
PREFIX='./'`hostname -s`_`date +%d-%m-%Y`
file=./check.txt
failed_list=`cat $PREFIX"_"failed.out | wc -l`
running_list=`cat $PREFIX"_"running.out | wc -l`
restart_list=`cut -b 78-86 list.out | grep [1-9] | wc -l`
curl https://raw.githubusercontent.com/GreatMedivack/files/master/list.out -o ./list.out
cat list.out | grep "Error\|CrashLoopBackOff" | cut -b 1-50  | awk -F'-' '{print $1 "-"  $2 "-"  $3 "-" $4  }' > $PREFIX"_"failed.out
cat list.out | grep Running | cut -b 1-50 | awk -F'-' '{print $1 "-"  $2 "-"  $3 "-"  $4  }' > $PREFIX"_"running.out
##cat list.out | grep Running | cut -b 1-50  | awk -F '-' '{if ($4=1-9) print $1 "-"  $2 "-"  $3"-"  $4 ; else print $1 "-"  $2 "-"  $3 "-"  }' > $PREFIX"_"running.out
echo "User: "$USER""   > $PREFIX"_"report.out
sleep 1
echo "Date: "$DATE"" >> $PREFIX"_"report.out
echo "Services running:" $running_list >> $PREFIX"_"report.out
echo "Services failed:" $failed_list >> $PREFIX"_"report.out
echo "Services restarted:" $restart_list >> $PREFIX"_"report.out
chmod o+r $PREFIX"_"report.out # or use "chmod 4 $PREFIX"_"report.out"
mkdir ./archives
tar -rf $PREFIX.tar *.out 
mv $PREFIX.tar ./archives
rm *.out*
for x in /root/projects/medods/archives/*;
    do
        if [ -f $x ]; then
           tar -tf $x > /dev/null 2>&1 && echo $date : $x archive is good > $file || \
                                          echo $date : $x archive is  bad >> $file;
        else
           tar -tf $x > /dev/null 2>&1 && echo $date : $x archive is good > $file  || \
                                          echo $date : $x archive is  bad > $file;
        fi
    done

cat $file | grep -o "archive is good\|archive is  bad"
