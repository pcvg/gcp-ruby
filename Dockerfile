FROM ruby:3.4.6

LABEL version="3.4.6"
LABEL maintainer="Ain Tohvri <ain.tohvri@savings-united.com>"

RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg && \
    curl -fsSL https://get.docker.com -o get-docker.sh && sh get-docker.sh && \
    curl -sL https://deb.nodesource.com/setup_22.x | bash - && \
    wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | gpg --dearmor -o /usr/share/keyrings/chrome.gpg && \
    sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/chrome.gpg] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' && \
    apt update && \
    apt install -y google-cloud-sdk nodejs google-chrome-unstable imagemagick libmagickwand-dev --no-install-recommends && \
    npm install -g corepack && \
    yarn set version stable && \
    rm /package.json && \
    apt autoremove && \
    apt autoclean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /var/lib/cache/*
