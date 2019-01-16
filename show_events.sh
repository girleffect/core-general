#!/bin/bash
#
# A script to pull all events published to the Kinesis service on localstacl
#

LOCALSTACK_IMAGE=$(docker ps -q -f name=localstack)
DOCKER_EXEC_CMD="docker exec -ti ${LOCALSTACK_IMAGE}"
STREAM_JSON_INFO=$(${DOCKER_EXEC_CMD} awslocal kinesis describe-stream --stream-name=test-stream)

SHARD_ID=$(echo ${STREAM_JSON_INFO} | jq '.StreamDescription.Shards[0].ShardId')
STARTING_SEQUENCE_NUMBER=$(echo ${STREAM_JSON_INFO} | jq '.StreamDescription.Shards[0].SequenceNumberRange.StartingSequenceNumber')
# printf "Starting sequence nunmber: %s\n" "${STARTING_SEQUENCE_NUMBER}"

SHARD_ITERATOR=$(${DOCKER_EXEC_CMD} awslocal kinesis get-shard-iterator --stream-name=test-stream --shard-id=${SHARD_ID//\"/} --shard-iterator-type=AT_SEQUENCE_NUMBER --starting-sequence-number=${STARTING_SEQUENCE_NUMBER//\"/} | jq ".ShardIterator")
# printf "Shard iterator: %s\n" "${SHARD_ITERATOR}"

${DOCKER_EXEC_CMD} awslocal kinesis get-records --shard-iterator=${SHARD_ITERATOR//\"/} | jq ".Records[].Data" | while read foo; do
    echo ${foo//\"/} | base64 -d | python -mjson.tool
done
