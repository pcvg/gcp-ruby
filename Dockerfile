FROM ruby:2.4

MAINTAINER Ain Tohvri <ain.tohvri@savings-united.com>

RUN echo "deb http://packages.cloud.google.com/apt cloud-sdk-jessie main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
      curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
      curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash - && \
      apt-get update && \
      apt-get install -y kubectl \
        google-cloud-sdk \
        google-cloud-sdk-datastore-emulator \
        google-cloud-sdk-pubsub-emulator \
        google-cloud-sdk-app-engine-go \
        google-cloud-sdk-app-engine-java \
        google-cloud-sdk-app-engine-python \
        google-cloud-sdk-cbt \
        google-cloud-sdk-bigtable-emulator \
        google-cloud-sdk-datalab && \
        nodejs && \
      apt-get autoremove && \
      wget https://dl.google.com/cloudsql/cloud_sql_proxy.linux.amd64 -O ~/cloud_sql_proxy && \
      chmod +x ~/cloud_sql_proxy && \
      mkdir /cloudsql && \
      gem install bundler
