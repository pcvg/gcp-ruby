FROM ruby:2.7.4

LABEL version="2.7.4"
LABEL maintainer="Ain Tohvri <ain.tohvri@savings-united.com>"

RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
      curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg add - && \
      curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
      echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
      curl -fsSL https://get.docker.com -o get-docker.sh && sh get-docker.sh && \
      curl -sL https://deb.nodesource.com/setup_16.x | bash - && \
      wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
      sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' && \
      apt-get update && \
      apt-get install -y gcc python-dev python-pip python-setuptools google-cloud-sdk nodejs yarn google-chrome-unstable --no-install-recommends && \
      apt-get autoremove && \
      rm -rf /var/lib/apt/lists/* && \
      pip install --no-cache-dir -U crcmod && \
      wget -q https://dl.google.com/cloudsql/cloud_sql_proxy.linux.amd64 -O ~/cloud_sql_proxy && \
      chmod +x ~/cloud_sql_proxy && \
      mkdir /cloudsql
