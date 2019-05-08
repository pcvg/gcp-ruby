#
# Workflow for testing PRs and publishing latest release off master
#

workflow "Build and Publish" {
  on = "push"
  resolves = "Docker Publish"
}

action "Entry Filter" {
  uses = "actions/bin/filter@master"
  args = "not deleted"
}

action "Tag Filter" {
  uses = "actions/bin/filter@master"
  args = "not tag"
}

action "Docker Lint" {
  needs = ["Entry Filter"]
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

action "Test Google Chrome" {
  needs = ["Build"]
  uses = "actions/docker/cli@master"
  args = "run gcp-ruby bash -c 'which google-chrome || exit 1'"
}

action "Publish Filter" {
  needs = ["Tag Filter", "Test Ruby", "Test Bundler", "Test Google Cloud SDK", "Test Cloud SQL Proxy", "Test Node.js", "Test Yarn", "Test Google Chrome"]
  uses = "actions/bin/filter@master"
  args = "branch master"
}

action "Docker Tag Latest" {
  needs = ["Publish Filter"]
  uses = "actions/docker/cli@master"
  args = "tag gcp-ruby savingsutd/gcp-ruby:latest"
}

action "Docker Login for Latest" {
  needs = ["Publish Filter"]
  uses = "actions/docker/login@master"
  secrets = ["DOCKER_USERNAME", "DOCKER_PASSWORD"]
}

action "Docker Publish" {
  needs = ["Docker Tag Latest", "Docker Login for Latest"]
  uses = "actions/docker/cli@master"
  args = "push savingsutd/gcp-ruby"
}

#
# Workflow for testing and publishing tag releases
#

workflow "Release" {
  on = "release"
  resolves = "Docker Release"
}

action "Docker Tag Release" {
  needs = ["Test Ruby", "Test Bundler", "Test Google Cloud SDK", "Test Cloud SQL Proxy", "Test Node.js", "Test Yarn", "Test Google Chrome"]
  uses = "actions/docker/tag@master"
  args = "gcp-ruby savingsutd/gcp-ruby --no-sha --no-latest"
}

action "Docker Login for Release" {
  needs = ["Test Ruby", "Test Bundler", "Test Google Cloud SDK", "Test Cloud SQL Proxy", "Test Node.js", "Test Yarn", "Test Google Chrome"]
  uses = "actions/docker/login@master"
  secrets = ["DOCKER_USERNAME", "DOCKER_PASSWORD"]
}

action "Docker Release" {
  needs = ["Docker Tag Release", "Docker Login for Release"]
  uses = "actions/docker/cli@master"
  args = "push savingsutd/gcp-ruby"
}
