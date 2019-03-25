workflow "Build and test" {
  on = "push"
  resolves = ["Test Ruby", "Test Bundler", "Test Google Cloud SDK", "Test Cloud SQL", "Test Node", "Test Yarn", "Test Privileges"]
}

action "Build image" {
  uses = "actions/docker/cli@8cdf801b322af5f369e00d85e9cf3a7122f49108"
  runs = "docker build . -t gcp-ruby:2.6.1 "
}

action "Test Ruby" {
  uses = "actions/docker/cli@8cdf801b322af5f369e00d85e9cf3a7122f49108"
  needs = ["Build image"]
  runs = "docker run gcp-ruby:2.6.1 bash -c \"which ruby || (printf 'ruby not found.'; exit 1)\""
}

action "Test Bundler" {
  uses = "actions/docker/cli@8cdf801b322af5f369e00d85e9cf3a7122f49108"
  needs = ["Build image"]
  runs = "docker run gcp-ruby:2.6.1 bash -c \"which bundle || (printf 'bundle ot found.'; exit 1)\""
}

action "Test Google Cloud SDK" {
  uses = "actions/docker/cli@8cdf801b322af5f369e00d85e9cf3a7122f49108"
  needs = ["Build image"]
  runs = "docker run gcp-ruby:2.6.1 bash -c \"which gcloud || (printf 'gcloud not found.'; exit 1)\""
}

action "Test Cloud SQL" {
  uses = "actions/docker/cli@8cdf801b322af5f369e00d85e9cf3a7122f49108"
  needs = ["Build image"]
  runs = "docker run gcp-ruby:2.6.1 bash -c \"test -f ~/cloud_sql_proxy || (printf 'cloud_sql_proxy not found.'; exit 1)\""
}

action "Test Node" {
  uses = "actions/docker/cli@8cdf801b322af5f369e00d85e9cf3a7122f49108"
  needs = ["Build image"]
  runs = "docker run gcp-ruby:2.6.1 bash -c \"which node || (printf 'node not found.'; exit 1)\""
}

action "Test Yarn" {
  uses = "actions/docker/cli@8cdf801b322af5f369e00d85e9cf3a7122f49108"
  needs = ["Build image"]
  runs = "docker run gcp-ruby:2.6.1 bash -c \"which yarn || (printf 'yarn not found.'; exit 1)\""
}

action "Test Privileges" {
  uses = "actions/docker/cli@8cdf801b322af5f369e00d85e9cf3a7122f49108"
  needs = ["Build image"]
  runs = "docker run gcp-ruby:2.6.1 bash -c \"touch /cloudsql/test.txt\""
}

