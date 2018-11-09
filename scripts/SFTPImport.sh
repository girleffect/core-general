#!/bin/bash

# REMOTE_HOST, USERNAME, REMOTE_DIR, FILES

RH_ERROR="Remote host is needed"
RD_ERROR="Remote directory is needed"

scp -rf ${FILES:- *} \
"${USERNAME:- $(hostname -i)}@${REMOTE_HOST:? $RH_ERROR}:${REMOTE_DIR:? $RD_ERROR}" \
-P 22
