#!/bin/sh


### Constant list ###
FILE="debug.log"
#LIMIT_SIZE=`expr 1024  \* 3` #3MB
LIMIT_SIZE=`expr 1024 \* 1024 \* 3` #3MB
GZIP_HOME=`which gzip`
WP_CONTENT_HOME="."
LOG_DIR="logs"
DM="[DEBUG]"
CF="[CONFIG]"



### LOG OUTPUT SETTING###
LOG_BUFFER=""
function append_log(){
	LOG_BUFFER="$LOG_BUFFER$1\r\n"
}
function print_log(){
	echo $LOG_BUFFER
}



cd ${WP_CONTENT_HOME}



### LOG ###
append_log "###### LOG GZIP PROCESS START ###### "
append_log "[DATE]`date`"



### Find File ###
if [ -e ${FILE} ] ; then
        append_log "${DM}${FILE} Found."
else
        append_log "${DM}ERROR:${FILE} Not Found."
        append_log "###### LOG GZIP PROCESS END ###### "
	#print_log
        exit 0
fi



### Decide whether do compression ###
file_size=`wc -c ${FILE} | awk '{printf $1}'`
append_log "${DM}CURRENT FILE SIZE:${file_size} byte"

if [ ${file_size} -lt ${LIMIT_SIZE} ] ; then
        append_log "${DM}No Need to gzip now.End."
        append_log "###### LOG GZIP PROCESS END ###### "
	#print_log
        exit 0
fi



### Create directory if not exists ###
if [ ! -e ${LOG_DIR} ] ; then
        mkdir ${LOG_DIR}
        append_log "${DM}Create \"${LOG_DIR}\" Directory."
fi



### Deciside version number ###
current_file=`ls -r ${LOG_DIR}/${FILE}* | head -1`
append_log "${DM}current_file=$current_file"
current_num=`printf %3g ${current_file##${LOG_DIR}/${FILE}.}`

next_num=`expr $current_num + 1`
next_num=`printf %03g ${next_num}`
append_log "${DM}CUR-NUM=$current_num,NEXT-NUM=$next_num"



### Do gzip compression ###
${GZIP_HOME} ${FILE} -c > ${LOG_DIR}/${FILE}.${next_num}
cp /dev/null ${FILE}



### Check if compressed properly ###
if [ -e ${LOG_DIR}/$FILE.$next_num ] ; then
        append_log "${DM}Done gzip compression. New Create ${FILE}.${next_num}"
else
        append_log "${DM}Fail gzip compression. Cannot create ${FILE}.${next_num}"
fi


### LOG ###
append_log "###### LOG GZIP PROCESS END ###### "
print_log
exit 0

