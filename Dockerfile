FROM aspgems/ruby:2.3-slim
MAINTAINER aspgems

RUN apt-get update && \
  apt-get install -qq -y --no-install-recommends \
    ssh \
    git \
    vim 

ENV LANG=C.UTF-8

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
