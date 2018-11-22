#!/bin/sh -vx

# REMOTE_HOST, USERNAME, REMOTE_DIR, FILES

# usage
# `./SFTPImport.sh -p <password> -u "bib" -h 197.210.150.250  -d /home/aphiwe/bar -f GC_RAW_DATA/*.csv \
#       -a <S3 access token> -s <S3 secret key> -b <S3 bucket name[prefix]>`

# -u Username
# -p Password
# -h ssh host machine
# -d Is the directory (without trailing slash) to dump the contents of -f (files)
# -f Files to Download from from remote machine
# -b S3 Bucket name
# -a S3 Access token
# -s S3 Secret Key

D_ERROR="Directory is required"
RH_ERROR="Remote host is required"
P_ERROR="User password is required"
RU_ERROR="Remote username is required"
S3_ERROR="S3 bucket is required"

while getopts ":d:f:h:u:p:b:a:s:" option
do
 case "${option}" in
 d) DIR=${OPTARG};;
 f) FILES=${OPTARG};;
 h) REMOTE_HOST=${OPTARG};;
 u) USERNAME=${OPTARG};;
 p) PASSWORD=${OPTARG};;
 b) BUCKET=${OPTARG};;
 a) ACCESS_KEY=${OPTARG};;
 s) SECRET_KEY=${OPTARG};;
 esac
done

sshpass -p ${PASSWORD:? $P_ERROR} sftp -a ${USERNAME:? $RU_ERROR}@${REMOTE_HOST:? $RH_ERROR}:${FILES:- *} ${DIR:? $D_ERROR}

# upload downloaded to S3
s3cmd sync --secret_key=${SECRET_KEY} --access_key=${ACCESS_KEY} ${DIR:? $D_ERROR}/${FILES:- *} s3://${BUCKET:? S3_ERROR}/
