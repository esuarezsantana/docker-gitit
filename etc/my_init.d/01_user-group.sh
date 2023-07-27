#!/bin/bash

source /etc/my_init.d/include/gitit

if [[ "${MY_DEBUG}" = 1 ]]; then
  source /etc/my_init.d/include/debug
else
  source /etc/my_init.d/include/no_debug
fi

USER="${GITIT_USER}"
GROUP="${GITIT_GROUP}"

if getent passwd "${USER}" &>/dev/null; then
  echo "User '${USER}' already exists."
else
  echo "User '${USER}' not found. Creating."
  # This will create the group as well.
  useradd -Ums /bin/bash "${USER}"
  usermod -p '*' "${USER}"
fi

if getent group "${GROUP}" &>/dev/null; then
  echo "Group '${GROUP}' already exists."
else
  echo "Group '${GROUP}' not found. Creating."
  groupadd "${GROUP}"
fi

