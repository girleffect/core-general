#!/bin/bash

REPO=girleffect/robot-test-automation
# Map "master" branch to "latest" tag. "develop" branch will have the "develop" tag.
TAG=${TRAVIS_BRANCH/master/latest}
# Tags may not contain slashes. Since git flow uses slashes as part of the branch name,
# we replace all slashes with underscores, i.e. "release/1.0.0-alpha" becomes "release_1.0.0-alpha".
TAG=${TAG//\//_}

docker build -t ${REPO}:${TAG} .
docker login -u="${DOCKER_USERNAME}" -p="${DOCKER_PASSWORD}"
docker -D push ${REPO}
