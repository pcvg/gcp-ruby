workflow "Release" {
  on = "release"
  resolves = "Docker Release"
}

action "Docker Lint" {
  uses = "docker://replicated/dockerfilelint"
  args = ["Dockerfile"]
}

action "Build" {
  needs = ["Docker Lint"]
  uses = "actions/docker/cli@master"
  args = "build -t gcp-ruby ."
}

action "Test Ruby" {
  needs = ["Build"]
  uses = "actions/docker/cli@master"
  args = "run gcp-ruby bash -c 'which ruby || exit 1'"
}

action "Test Bundler" {
  needs = ["Build"]
  uses = "actions/docker/cli@master"
  args = "run gcp-ruby bash -c 'which bundle || exit 1'"
}

action "Test Google Cloud SDK" {
  needs = ["Build"]
  uses = "actions/docker/cli@master"
  args = "run gcp-ruby bash -c 'which gcloud || exit 1'"
}

action "Test Cloud SQL Proxy" {
  needs = ["Build"]
  uses = "actions/docker/cli@master"
  args = "run gcp-ruby bash -c 'test -f ~/cloud_sql_proxy && touch /cloudsql/.keep && rm /cloudsql/.keep || exit 1'"
}

action "Test Node.js" {
  needs = ["Build"]
  uses = "actions/docker/cli@master"
  args = "run gcp-ruby bash -c 'which node || exit 1'"
}

action "Test Yarn" {
  needs = ["Build"]
  uses = "actions/docker/cli@master"
  args = "run gcp-ruby bash -c 'which yarn || exit 1'"
}

# TODO: send notifications
action "Conclude tests" {
  needs = ["Test Ruby", "Test Bundler", "Test Google Cloud SDK", "Test Cloud SQL Proxy", "Test Node.js", "Test Yarn"]
  uses = "actions/bin/sh@master"
  args = ["exit 0"]
}

action "Release Filter" {
  needs = ["Conclude Tests"]
  uses = "actions/bin/filter@master"
  args = "tag"
}

action "Docker Login" {
  needs = ["Release Filter"]
  uses = "actions/docker/login@master"
  secrets = ["DOCKER_USERNAME", "DOCKER_PASSWORD"]
}

action "Docker Tag Release" {
  needs = ["Release Filter"]
  uses = "actions/docker/tag@master"
  args = "gcp-ruby savingsutd/gcp-ruby --no-latest --no-sha"
}

action "Docker Release" {
  needs = ["Docker Tag Release", "Docker Login"]
  uses = "actions/docker/cli@master"
  args = "push savingsutd/gcp-ruby"
}