#!/bin/sh -v

# REMOTE_HOST, USERNAME, REMOTE_DIR, FILES

# usage `./SFTPImport.sh -u "bib" -h 197.210.150.250  -d /home/aphiwe/bar -f "GC_RAW_DATA/*.csv`

D_ERROR="Directory is needed"
RH_ERROR="Remote host is needed"
RU_ERROR="Remote username is needed"

while getopts ":d:f:h:u:" option
do
 case "${option}" in
 d) DIR=${OPTARG};;
 f) FILES=${OPTARG};;
 h) REMOTE_HOST=${OPTARG};;
 u) USERNAME=${OPTARG};;
 esac
done

scp -vr ${USERNAME:? $RU_ERROR}@${REMOTE_HOST:? $RH_ERROR}:${FILES:- *} ${DIR:? $D_ERROR}