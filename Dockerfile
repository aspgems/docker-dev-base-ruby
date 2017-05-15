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
  && rm -rf /var/lib/apt/lists*


ENV LANG=C.UTF-8

ARG USER_NAME=dev
ARG USER_UID=1000
ARG USER_GID=1000

ENV APP_HOME=/home/${USER_NAME}

ENV GEM_HOME=${APP_HOME}/vendor/bundle
ENV BUNDLE_PATH $GEM_HOME
ENV BUNDLE_BIN $BUNDLE_PATH/bin
ENV PATH $BUNDLE_BIN:$PATH

RUN mkdir /root/.ssh && echo "StrictHostKeyChecking no" > /root/.ssh/config

COPY setup_user.sh /bin/setup_user.sh
RUN chmod +x /bin/setup_user.sh

RUN /bin/setup_user.sh
USER ${USER_NAME}

WORKDIR /${APP_HOME}

CMD ["bash"]
