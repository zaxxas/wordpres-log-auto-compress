#!/bin/bash


######## Constant list #########
FILE="debug.log"
LIMIT_SIZE=`expr 1024 \* 1024 \* 2` #2MB
GZIP_HOME=`which gzip`
# Wordpress(wp-content) Directory Home#
WP_CONTENT_HOME="."
# Log Directory Name#
LOG_DIR="logs"
# Max Log Number #
MAX_LOG_NUM=3
# The Number Of Digits #
NUM_DIGITS=3
# Debug Message #
DM="[DEBUG]"
CF="[CONFIG]"
# newline code #
NC="\n"



######### LOG OUTPUT FUNCTION ##########
LOG_BUFFER=""
# Append log for log output #
function append_log(){
	LOG_BUFFER="$LOG_BUFFER$1$NC"
}
# print log #
function print_log(){
	echo -e "$LOG_BUFFER"
}
# change log version number #
function change_log_num(){
	
	for file in `ls -r ${LOG_DIR}/${FILE}*`
		do
			current_num=`printf %${NUM_DIGITS}g ${file##${LOG_DIR}/${FILE}.}`
			if [ ${current_num} -ge ${MAX_LOG_NUM} ] ; then
				append_log "${DM}rm -f ${file}"
				rm -f $file
				continue
			fi

			next_num=`expr $current_num + 1`
			next_num=`printf %0${NUM_DIGITS}g ${next_num}`

			append_log "${DM}mv ${file} ${LOG_DIR}/${FILE}.${next_num}"
			mv ${file} ${LOG_DIR}/${FILE}.${next_num}
		done
}
	



cd ${WP_CONTENT_HOME}



### Log Pring ###
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



### Change Log File Version Number ###
change_log_num
	
	

### Do gzip compression ###
VERSION_NUM=`printf %0${NUM_DIGITS}g 1`
NEXT_FILE=${LOG_DIR}/${FILE}.${VERSION_NUM}

${GZIP_HOME} ${FILE} -c > ${NEXT_FILE}
cp /dev/null ${FILE}



### Check if compressed properly ###
if [ -e ${NEXT_FILE} ] ; then
        append_log "${DM}Done gzip compression. New Create ${NEXT_FILE}"
else
        append_log "${DM}Fail gzip compression. Cannot create ${NEXT_FILE}"
fi


### Log Pring And Exit ###
append_log "###### LOG GZIP PROCESS END ###### "
print_log
exit 0

