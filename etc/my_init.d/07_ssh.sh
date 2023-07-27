#!/bin/bash

source /etc/my_init.d/include/gitit

if [[ "${MY_DEBUG}" = 1 ]]; then
  source /etc/my_init.d/include/debug
else
  source /etc/my_init.d/include/no_debug
fi

BASE_DIR="${GITIT_DIR}"
SSH_AUTHORIZED_KEYS="${BASE_DIR}/etc/authorized_keys"

FILE="/etc/ssh/sshd_config"
LINE="AuthorizedKeysFile ${SSH_AUTHORIZED_KEYS}"
grep -qxF -- "$LINE" "$FILE" || echo "$LINE" >> "$FILE"
