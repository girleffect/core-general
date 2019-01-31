#!/usr/bin/env sh

while true; do
    awslocal kinesis create-stream --stream-name=${TEST_STREAM} --shard-count=1

    if [ $? -eq 0 ]; then
        echo "createStream.sh; Kinesis stream created"
        break
    fi

    echo "createStream.sh; Error creating stream, retrying in a moment"
    sleep 10
done

echo "createStream.sh; DONE"
