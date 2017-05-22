# #!/bin/bash -x
# echo "adding group"
# addgroup --gid $USER_GID $USER_NAME
#
# echo "adding user"
# adduser --home $USER_HOME --uid $USER_UID --gid $USER_GID $USER_NAME
# mkdir -p ${USER_HOME}
echo "looking for group"
# Create group if not exists
cut -d':' -f 3 /etc/group | grep -q "^$USER_GID$"
if [ $? -ne 0 ]; then
  echo "creating group"
  addgroup --gid $USER_GID $USER_NAME
fi

# Create user if not exists
echo "looking for user"
cut -d':' -f 3 /etc/passwd | grep -q "^$USER_UID$"
if [ $? -ne 0 ]; then
  echo "creating user"
  adduser --home $USER_HOME --shell /bin/bash --uid $USER_UID --gid $USER_GID $USER_NAME --disabled-password --gecos 'development user'
fi
export SSH_PATH=$USER_HOME/.ssh
mkdir -p $SSH_PATH && echo "StrictHostKeyChecking no" > $SSH_PATH/config
chown -R $USER_UID:$USER_GID $USER_HOME
