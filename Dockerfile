FROM circleci/ruby:2.5.1-node-browsers

MAINTAINER Ain Tohvri <ain.tohvri@savings-united.com>

RUN echo "deb http://packages.cloud.google.com/apt cloud-sdk-jessie main" | sudo tee /etc/apt/sources.list.d/google-cloud-sdk.list && \
      sudo curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add - && \
      sudo apt-get update && \
      sudo apt-get install -y kubectl \
        google-cloud-sdk \
        google-cloud-sdk-datastore-emulator \
        google-cloud-sdk-pubsub-emulator \
        google-cloud-sdk-app-engine-go \
        google-cloud-sdk-app-engine-java \
        google-cloud-sdk-app-engine-python \
        google-cloud-sdk-cbt \
        google-cloud-sdk-bigtable-emulator \
        google-cloud-sdk-datalab && \
      sudo apt-get autoremove && \
      sudo wget https://dl.google.com/cloudsql/cloud_sql_proxy.linux.amd64 -O ~/cloud_sql_proxy && \
      sudo chmod +x ~/cloud_sql_proxy && \
      sudo mkdir /cloudsql
