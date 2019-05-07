FROM ruby:2.6.3

LABEL version="2.6.3"
LABEL maintainer="Ain Tohvri <ain.tohvri@savings-united.com>"

RUN echo "deb http://packages.cloud.google.com/apt cloud-sdk-jessie main" | tee /etc/apt/sources.list.d/google-cloud-sdk.list && \
      curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
      echo "deb http://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
      curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
      curl -sL https://deb.nodesource.com/setup_11.x | bash - && \
      wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
          sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' && \
          apt-get update && \
          apt-get install -y google-chrome-unstable fonts-ipafont-gothic fonts-wqy-zenhei fonts-thai-tlwg fonts-kacst ttf-freefont \
            --no-install-recommends && \
          rm -rf /var/lib/apt/lists/* && \
      apt-get install gcc python-dev python-setuptools && \
      pip uninstall crcmod && \
      pip install --no-cache-dir -U crcmod && \
      apt-get update && \
      apt-get install --no-install-recommends -y google-cloud-sdk nodejs yarn && \
      apt-get autoremove && \
      rm -rf /var/lib/apt/lists/* && \
      wget https://dl.google.com/cloudsql/cloud_sql_proxy.linux.amd64 -O ~/cloud_sql_proxy && \
      chmod +x ~/cloud_sql_proxy && \
      mkdir /cloudsql

USER pptruser

CMD ["google-chrome-unstable"]
