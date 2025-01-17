#!/bin/bash

. ${HOME}/klipper-s3bck/.config

DT=$(date +%Y%m%d-%H%M%S)

set -f
folders=(${SOURCE_FOLDERS//:/ })

if [ -z $RETENTION_DURATION ]; then RETENTION_DURATION=1d; fi
if [ -z $RETENTION_MODE ]; then RETENTION_MODE=governance; fi

for i in "${!folders[@]}"
do
  echo "$i=>${folders[i]}"
  mc cp -q --dp --retention-mode $RETENTION_MODE --retention-duration $RETENTION_DURATION -r ${folders[i]}/ ${MC_ALIAS}/${BUCKET}/${SYS_NAME}/${DT}/${folders[i]}
  mc rm  --older-than ${KEEP_BACKUPS}d ${folders[i]} ${MC_ALIAS}/${BUCKET}/${SYS_NAME}
done
