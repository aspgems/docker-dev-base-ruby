FROM ruby:2.3-slim
MAINTAINER aspgems

RUN apt-get update && \
  apt-get install -qq -y --no-install-recommends \
    build-essential \
    libpq-dev \
    postgresql-client \
    nodejs \
    tzdata \
    libxml2-dev \
    libxslt-dev \
    ssh \
    git \
    vim \
    wget \
    bash-completion

# Install tmux
USER root
RUN apt-get install -y -qq --no-install-recommends libevent-dev libncurses-dev
RUN cd /tmp && wget https://github.com/tmux/tmux/releases/download/2.4/tmux-2.4.tar.gz 
RUN cd /tmp && tar -zxvf /tmp/tmux-2.4.tar.gz && cd /tmp/tmux-2.4 && ./configure && make && make install


ENV APP_HOME=/app

ENV BUNDLE_PATH=$APP_HOME/vendor/bundle
ENV BUNDLE_BIN $BUNDLE_PATH/bin
ENV BUNDLE_APP_CONFIG $APP_HOME/.bundle
ENV PATH $BUNDLE_BIN:$PATH
WORKDIR /${APP_HOME}

ENV LANG=C.UTF-8

ENV USER_GID=1000
ENV USER_UID=1000
ENV USER_NAME=developer
ENV USER_HOME /home/$USER_NAME
ENV SSH_PATH=$USER_HOME/.ssh

# User creation
COPY setup_user.sh /bin/setup_user.sh
RUN chmod +x /bin/setup_user.sh

RUN setup_user.sh

USER $USER_NAME

# dotfiles
ARG CASTLES=elafo/vim-dot-files,elafo/bash-dot-files,elafo/tmux-dot-files,elafo/git-dot-files
ENV CASTLES=$CASTLES

USER root
RUN gem install homesick --no-rdoc --no-ri
COPY add_castles.rb $USER_HOME/add_castles.rb
RUN chmod +x $USER_HOME/add_castles.rb
USER $USER_NAME

RUN ruby $USER_HOME/add_castles.rb

# Config TERM
ENV TERM=screen-256color

# Config IDE
RUN exec vim -c ":PluginInstall" -c "qall"

CMD ["echo", "Dev environment set up"]
