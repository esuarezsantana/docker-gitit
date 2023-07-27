#!/bin/bash

source /etc/my_init.d/include/gitit

if [[ "${MY_DEBUG}" = 1 ]]; then
    source /etc/my_init.d/include/debug
else
    source /etc/my_init.d/include/no_debug
fi

BASE_DIR="${GITIT_DIR}"
USER="${GITIT_USER}"
GROUP="${GITIT_GROUP}"
CONF="${BASE_DIR}/etc/gitit.conf"
BINENV="/etc/service/gitit/env"

if [[ -f "${CONF}" ]]; then
  echo "Conf file found."
else
  echo "Conf file not found. Creating."
  chpst -u "${USER}:${GROUP}" -e "${BINENV}" gitit --print-default-config > "${CONF}"
fi

patch_conf () {
    local LINE_OLD="$1"
    local LINE_NEW="$2"
    if grep -qxF -- "${LINE_NEW}" "${CONF}"; then
        echo "  - already set: '${LINE_NEW}'"
    else
        echo "  - patching: '${LINE_NEW}'"
        sed -i "/${LINE_OLD}/c ${LINE_NEW}" "${CONF}"
    fi
}

echo "Patching conf file:"
patch_conf "^cache-dir: [[:alnum:]/]" "cache-dir: ${BASE_DIR}/var/cache"
patch_conf "^user-file: [[:alnum:]/]" "user-file: ${BASE_DIR}/var/lib/gitit-users"
patch_conf "^log-file: [[:alnum:]/]" "log-file: ${BASE_DIR}/var/log/gitit.log"
patch_conf "^static-dir: [[:alnum:]/]" "static-dir: ${BASE_DIR}/var/www/static"
patch_conf "^templates-dir: [[:alnum:]/]" "templates-dir: ${BASE_DIR}/var/www/templates"
patch_conf "^repository-path: [[:alnum:]/]" "repository-path: ${BASE_DIR}/var/www/wikidata"

