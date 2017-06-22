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

ENV WORKSPACE_HOME=/workspace

ENV BUNDLE_PATH=$WORKSPACE_HOME/vendor/bundle
ENV BUNDLE_BIN $BUNDLE_PATH/bin
ENV BUNDLE_APP_CONFIG $WORKSPACE_HOME/.bundle
ENV PATH $BUNDLE_BIN:$PATH
WORKDIR /${WORKSPACE_HOME}

# Dev environment configuration
ENV USER_GID=1000
ENV USER_UID=1000
ENV USER_NAME=developer
ENV USER_HOME /home/$USER_NAME
ENV SSH_PATH=$USER_HOME/.ssh

COPY setup_user.sh /bin/setup_user.sh
RUN chmod +x /bin/setup_user.sh

RUN setup_user.sh

USER $USER_NAME
CMD ["echo", "Dev environment set up"]
