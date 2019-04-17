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
