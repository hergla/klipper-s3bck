#!/bin/bash

. ${HOME}/klipper-s3bck/.config

LOGFILE=${HOME}/klipper-s3bck/backup.log

DT=$(date +%Y%m%d%H%M%S)

set -f
folders=(${SOURCE_FOLDERS//:/ })

if [ -z $RETENTION_DURATION ]; then RETENTION_DURATION=1d; fi
if [ -z $RETENTION_MODE ]; then RETENTION_MODE=governance; fi

for i in "${!folders[@]}"
do
  echo "Backup started for ${folders[i]}"
   echo "mc cp -q --dp --retention-mode $RETENTION_MODE --retention-duration $RETENTION_DURATION -r ${folders[i]}/ ${MC_ALIAS}/${BUCKET}/${SYS_NAME}/${DT}${folders[i]} > $LOGFILE 2>&1 "
   mc cp -q --dp --retention-mode $RETENTION_MODE --retention-duration $RETENTION_DURATION -r ${folders[i]}/ ${MC_ALIAS}/${BUCKET}/${SYS_NAME}/${DT}${folders[i]} > $LOGFILE 2>&1
  if [ $? -eq 0 ]
  then
    echo "Backup succeded for ${folders[i]}"
  else
    echo "Backup failed for ${folders[i]}"
  fi
done

echo "Remove backups older $KEEP_BACKUPS days."
mc rm  --older-than ${KEEP_BACKUPS}d ${folders[i]} ${MC_ALIAS}/${BUCKET}/${SYS_NAME} >> $LOGFILE 2>&1
if [ $? -ne 0 ]
then
  echo "Removeing backups failed."
fi
