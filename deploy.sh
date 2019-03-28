#/bin/bash

echo $DOCKER_PASSWORD | docker login --username $DOCKER_USERNAME --password-stdin

if [ "$TRAVIS_BRANCH" == "master" ]; then
  docker tag gcp-ruby:$VERSION gcp-ruby:latest
fi

docker push gcp-ruby:$1
