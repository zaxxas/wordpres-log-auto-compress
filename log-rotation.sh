#!/bin/sh


### Constant list ###
FILE="debug.log"
LIMIT_SIZE=`expr 1024 \* 1024 \* 3` #3MB
GZIP_HOME=`which gzip`
WP_CONTENT_HOME="."
LOG_DIR="logs"
DM="[DEBUG]"
CF="[CONFIG]"



cd ${WP_CONTENT_HOME}



echo "###### LOG GZIP PROCESS START ###### "
echo "[DATE]`date`"



### File exits ###
if [ -e ${FILE} ] ; then
        echo "${DM}${FILE} Found."
else
        echo "${DM}ERROR:${FILE} Not Found."
        echo "###### LOG GZIP PROCESS END ###### "
        exit 0
fi



### decision  ###
file_size=`wc -c ${FILE} | awk '{printf $1}'`
echo "${DM}CURRENT FILE SIZE:${file_size} byte"

if [ ${file_size} -lt ${LIMIT_SIZE} ] ; then
        echo "${DM}No Need to gzip now.End."
        echo "###### LOG GZIP PROCESS END ###### "
        exit 0
fi



### create directory if not exists ###
if [ ! -e ${LOG_DIR} ] ; then
        mkdir ${LOG_DIR}
        echo "${DM}Create \"${LOG_DIR}\" Directory."
fi



### decision of number ###
current_file=`ls -r ${LOG_DIR}/${FILE}* | head -1`
echo "${DM}current_file=$current_file"
#if [ ${current_file}
current_num=`printf %3g ${current_file##${LOG_DIR}/${FILE}.}`

next_num=`expr $current_num + 1`
next_num=`printf %03g ${next_num}`
echo "${DM}CUR-NUM=$current_num,NEXT-NUM=$next_num"



### do gzip compression ###
${GZIP_HOME} ${FILE} -c > ${LOG_DIR}/${FILE}.${next_num}
cp /dev/null ${FILE}



### output ###
if [ -e ${LOG_DIR}/$FILE.$next_num ] ; then
        echo "${DM}Done gzip compression. New Create ${FILE}.${next_num}"
else
        echo "${DM}Fail gzip compression. Cannot create ${FILE}.${next_num}"
fi



echo "###### LOG GZIP PROCESS END ###### "
exit 0

