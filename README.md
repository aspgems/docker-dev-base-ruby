# docker-dev-base-ruby
A dockerized ruby development environment.

First create a docker file with the minimum configuration:
```
ARG USER_UID=1000
ARG USER_GID=1000

ENV USER_UID $USER_UID
ENV USER_GID $USER_GID

RUN /bin/setup_user.sh
USER $USER_NAME
```

Then build the environment using
```
docker build --build-arg USER_UID=$(id -u) --build-arg USER_GID=$(id -g) .
```

To start the application there is two mounting points:
- /home/developer/app to mount with the actual application
- /tmp/agent.sock to mount our ssh_agent usually exported in the host as SSH_AUTH_SOCK
