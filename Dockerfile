FROM ruby:2.3-slim

RUN apt-get update && \
  apt-get install -qq -y --no-install-recommends \
    build-essential \
    libpq-dev \
    nodejs \
    tzdata \
    libxml2-dev \
    libxslt-dev \
    ssh \
    git \
  && rm -rf /var/lib/apt/lists*


ENV LANG=C.UTF-8

ENV USER_NAME dev
ENV APP_HOME=/home/$USER_NAME

ENV GEM_HOME=$APP_HOME/vendor/bundle
ENV BUNDLE_PATH $GEM_HOME
ENV BUNDLE_BIN $BUNDLE_PATH/bin
ENV BUNDLE_APP_CONFIG $APP_HOME/.bundle
ENV PATH $BUNDLE_BIN:$PATH

RUN mkdir /root/.ssh && echo "StrictHostKeyChecking no" > /root/.ssh/config

COPY setup_user.sh /bin/setup_user.sh
RUN chmod +x /bin/setup_user.sh

WORKDIR /${APP_HOME}

CMD ["echo", "Dev environment set up"]
