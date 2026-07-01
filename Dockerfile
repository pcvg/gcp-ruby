FROM ruby:3.4.10

LABEL version="3.4.10"
LABEL maintainer="Ain Tohvri <ain.tohvri@samwise-media.com>"

RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" \
      | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg && \
    curl -fsSL https://get.docker.com -o get-docker.sh && sh get-docker.sh && \
    curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /usr/share/keyrings/nodesource.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/nodesource.gpg] https://deb.nodesource.com/node_22.x nodistro main" \
      | tee /etc/apt/sources.list.d/nodesource.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
      google-cloud-sdk nodejs chromium python3-setuptools imagemagick libmagickwand-dev xvfb && \
    ln -sf /usr/bin/chromium /usr/local/bin/google-chrome && \
    corepack enable && \
    corepack prepare yarn@stable --activate && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
