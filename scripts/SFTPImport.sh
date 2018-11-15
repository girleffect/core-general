#!/bin/bash -v

# REMOTE_HOST, USERNAME, REMOTE_DIR, FILES

# usage `USERNAME=userftp REMOTE_HOST=127.0.0.1 PORT=22 FILES=*  REMOTE_DIR=/ ./scripts/SFTPImport.sh`

RH_ERROR="Remote host is needed"
RD_ERROR="Remote directory is needed"

echo scp -rf ${FILES:- *} "${USERNAME:- $(hostname -i)}@${REMOTE_HOST:? $RH_ERROR}:${REMOTE_DIR:? $RD_ERROR}" -P ${PORT:- 22}
