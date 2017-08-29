FROM ruby:2.4

MAINTAINER Ain Tohvri <ain.tohvri@savings-united.com>

RUN echo "deb http://packages.cloud.google.com/apt cloud-sdk-jessie main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
      curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
      apt-get update && \
      apt-get install -y google-cloud-sdk && \
      apt-get autoremove && \
      wget https://dl.google.com/cloudsql/cloud_sql_proxy.linux.amd64 -O ~/cloud_sql_proxy && \
      chmod +x ~/cloud_sql_proxy && \
      mkdir /cloudsql && \
      gem install bundler
