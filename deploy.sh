#!/bin/bash

set -ev

echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin

if [ "${TRAVIS_BRANCH}" = "master" ]; then
  docker tag savingsutd/gcp-ruby:$VERSION savingsutd/gcp-ruby:$1
fi

docker push savingsutd/gcp-ruby:$1
