#!/bin/sh -v

# REMOTE_HOST, USERNAME, REMOTE_DIR, FILES

# usage `SFTPImport.sh -u test -h 127.0.0.1 -d "/remote/path" -f "*"`

RH_ERROR="Remote host is needed"
RU_ERROR="Remote username is needed"
RD_ERROR="Remote directory is needed"

while getopts ":d:f:h:u:" option
do
 case "${option}" in
 d) REMOTE_DIR=${OPTARG};;
 f) FILES=${OPTARG};;
 h) REMOTE_HOST=${OPTARG};;
 u) USERNAME=${OPTARG};;
 esac
done

scp -vr ${FILES:- *} "${USERNAME:? $RU_ERROR}@${REMOTE_HOST:? $RH_ERROR}:${REMOTE_DIR:? $RD_ERROR}"
