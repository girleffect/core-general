#!/usr/bin/env bash

# Step into directory
cd ~/projects/girleffect/core-general

# Check if file exists
if [ -e Makefile ]
then

    # Run make run
    make run || exit_code=$?
    
    # Check if the code is equal to 1(failure)
    if [ $exit_code -eq 1 ] 
        then
            echo "Tests totes failed"
        else
            echo "Tests probably passed"
    fi  
else
    echo "File Makefile is missing, aborting..."
    cd ..
fi