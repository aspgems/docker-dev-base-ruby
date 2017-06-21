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
    sudo \
  && rm -rf /var/lib/apt/lists*


ENV LANG=C.UTF-8

ENV APP_HOME=/app

ENV GEM_HOME=$APP_HOME/vendor/bundle
ENV BUNDLE_PATH $GEM_HOME
ENV BUNDLE_BIN $BUNDLE_PATH/bin
ENV BUNDLE_APP_CONFIG $APP_HOME/.bundle
ENV PATH $BUNDLE_BIN:$PATH

WORKDIR /${APP_HOME}

# Dev environment configuration
ARG USER_NAME
ARG USER_GUID
ARG USER_UID
ENV USER_GID ${USER_GID:-1000}
ENV USER_UID ${USER_UID:-1000}
ENV USER_NAME ${USER_NAME:-developer}
ENV USER_HOME /home/$USER_NAME
ENV SSH_PATH=$USER_HOME/.ssh

#COPY setup_user.sh /bin/setup_user.sh
#RUN chmod +x /bin/setup_user.sh

RUN addgroup --gid $USER_GID $USER_NAME &&\ 
    useradd --gid $USER_GID --uid $USER_UID $USER_NAME -d $USER_HOME -m -s /bin/bash &&\
    adduser $USER_NAME sudo && \
		echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
RUN mkdir $SSH_PATH
#RUN setup_user.sh

USER $USER_NAME
CMD ["echo", "Dev environment set up"]
