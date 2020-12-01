#!/bin/bash

DATE="$(date +%F_%T)"

APP_BACKUP_DIR="/mnt/app/backup/${DATE}"
mkdir -p "${APP_BACKUP_DIR}"
cp -avr /mnt/app/pv/* "${APP_BACKUP_DIR}/"
umount /mnt/app/backup

if [ -f "/mnt/mysql/prod/rm_file.txt" ]; then
    MYSQL_BACKUP_DIR="/mnt/mysql/backup/${DATE}"
    mkdir -p "${MYSQL_BACKUP_DIR}"
    cp -avr /mnt/mysql/pv/* "${MYSQL_BACKUP_DIR}/"
    umount /mnt/mysql/backup
fi

APP_RM_FILE="/mnt/app/prod/rm_file.txt"
while IFS= read -r line
do
    if [ "x${line}" != "x" ]; then
        rm -rf "/mnt/app/pv/${line}"
    fi
done < "${APP_RM_FILE}"

if [ -f "/mnt/mysql/prod/rm_file.txt" ]; then
    MYSQL_RM_FILE="/mnt/mysql/prod/rm_file.txt"
    while IFS= read -r line
    do
        rm -rf /mnt/mysql/pv/${line}
    done < "${MYSQL_RM_FILE}"
fi

cp -avr /mnt/app/prod/* /mnt/app/pv/

if [ -f "/mnt/mysql/prod/rm_file.txt" ]; then
    cp -avr /mnt/mysql/prod/* /mnt/mysql/pv/
fi

exit 0
