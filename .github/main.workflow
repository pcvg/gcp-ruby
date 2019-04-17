workflow "Build and Publish" {
  on = "push"
  resolves = "Build"
}

action "Docker Lint" {
  uses = "docker://replicated/dockerfilelint"
  args = ["Dockerfile"]
}

action "Build" {
  needs = ["Docker Lint"]
  uses = "actions/docker/cli@master"
  args = "build -t savingsutd/gcp-ruby:latest ."
}

action "Test Ruby" {
  needs = ["Build"]
  uses = "actions/docker/cli@master"
  args = "run savingsutd/gcp-ruby:latest bash -c 'which ruby || exit 1'"
}

action "Test Bundler" {
  needs = ["Build"]
  uses = "actions/docker/cli@master"
  args = "run savingsutd/gcp-ruby:latest bash -c 'which bundle || exit 1'"
}

action "Test Google Cloud SDK" {
  needs = ["Build"]
  uses = "actions/docker/cli@master"
  args = "run savingsutd/gcp-ruby:latest bash -c 'which gcloud || exit 1'"
}

action "Test Cloud SQL Proxy" {
  needs = ["Build"]
  uses = "actions/docker/cli@master"
  args = "run savingsutd/gcp-ruby:latest bash -c 'test -f ~/cloud_sql_proxy && touch /cloudsql/.keep && rm /cloudsql/.keep || exit 1'"
}

action "Test Node.js" {
  needs = ["Build"]
  uses = "actions/docker/cli@master"
  args = "run savingsutd/gcp-ruby:latest bash -c 'which node || exit 1'"
}

action "Test Yarn" {
  needs = ["Build"]
  uses = "actions/docker/cli@master"
  args = "run savingsutd/gcp-ruby:latest bash -c 'which yarn || exit 1'"
}

action "Test Filter" {
  needs = ["Test Ruby", "Test Bundler", "Test Google Cloud SDK", "Test Cloud SQL Proxy", "Test Node.js", "Test Yarn"]
  uses = "actions/bin/filter@master"
  args = "branch"
}

action "Publish Filter" {
  needs = ["Test Filter"]
  uses = "actions/bin/filter@master"
  args = "branch master"
}

action "Docker Login" {
  needs = ["Publish Filter"]
  uses = "actions/docker/login@master"
  secrets = ["DOCKER_USERNAME", "DOCKER_PASSWORD"]
}

action "Docker Publish" {
  needs = ["Docker Tag", "Docker Login"]
  uses = "actions/docker/cli@master"
  args = "push savingsutd/gcp-ruby"
}
