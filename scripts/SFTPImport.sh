#!/bin/sh -vx

# REMOTE_HOST, USERNAME, REMOTE_DIR, FILES

# usage `./SFTPImport.sh -p <password> -u "bib" -h 197.210.150.250  -d /home/aphiwe/bar -f "GC_RAW_DATA/*.csv`

D_ERROR="Directory is required"
RH_ERROR="Remote host is required"
U_ERROR="User password is required"
RU_ERROR="Remote username is required"

while getopts ":d:f:h:u:p:" option
do
 case "${option}" in
 d) DIR=${OPTARG};;
 f) FILES=${OPTARG};;
 h) REMOTE_HOST=${OPTARG};;
 u) USERNAME=${OPTARG};;
 p) PASSWORD=${OPTARG};;
 esac
done

sshpass -p ${PASSWORD:? $U_ERROR} sftp -a ${USERNAME:? $RU_ERROR}@${REMOTE_HOST:? $RH_ERROR}:${FILES:- *} ${DIR:? $D_ERROR}