#!/bin/bash

source /etc/my_init.d/include/gitit

if [[ "${MY_DEBUG}" = 1 ]]; then
    source /etc/my_init.d/include/debug
else
    source /etc/my_init.d/include/no_debug
fi

create_dir () {
    local DIR="$1"
    if [[ -d "${DIR}" ]]; then
        echo "  - directory '${DIR}' exists"
    else
        echo "  - directory '${DIR}' does not exist, creating and setting permissions"
        # assume parent directory exists
        mkdir "${DIR}"
        chown "${NEW_UID}:${NEW_GID}" "${DIR}"
    fi
}

create_tree () {
    echo "Creating gitit tree:"
    create_dir "${BASE_DIR}"
    create_dir "${BASE_DIR}/etc"
    create_dir "${BASE_DIR}/var"
    create_dir "${BASE_DIR}/var/cache"
    create_dir "${BASE_DIR}/var/lib"
    create_dir "${BASE_DIR}/var/log"
    create_dir "${BASE_DIR}/var/www"
}

modify_uid_gid () {
    echo "Modifying permissions for user."
    usermod -u "${NEW_UID}" "${USER}"
    groupmod -g "${NEW_GID}" "${GROUP}"
    find / \( -name proc -o -name dev -o -name sys \) -prune \
         -o \( -user "${OLD_UID}" -exec chown -hv "${NEW_UID}" {} + \
         -o -group "${OLD_GID}" -exec chgrp -hv "${NEW_GID}" {} + \)
}

BASE_DIR="${GITIT_DIR}"
USER="${GITIT_USER}"
GROUP="${GITIT_GROUP}"
OLD_UID=$(getent passwd "${USER}" |  awk -F: '{ print $3 }')
OLD_GID=$(getent group "${GROUP}" |  awk -F: '{ print $3 }')

if [[ -d "${BASE_DIR}" ]]; then
    if [[ -d "${BASE_DIR}/etc" ]]; then
        echo "Directory '${BASE_DIR}/etc' exists. Reading uid:gid info."
        NEW_UID=$(stat -c %u "${BASE_DIR}/etc")
        NEW_GID=$(stat -c %g "${BASE_DIR}/etc")
    else
        echo "Directory '${BASE_DIR}' exists. Reading uid:gid info."
        NEW_UID=$(stat -c %u "${BASE_DIR}")
        NEW_GID=$(stat -c %g "${BASE_DIR}")
    fi
else
    echo "Base directory not found. Using default uid:gid info."
    NEW_UID="${OLD_UID}"
    NEW_GID="${OLD_GID}"
fi

if [[ ${USER} = "root" && ${NEW_UID} != 0 ]]; then
    echo "${BASE_DIR} must be root owned when running as root."
    exit 1;
fi

if [[ ${USER} != "root" && ${NEW_UID} = 0 ]]; then
    echo "${BASE_DIR} must NOT be root owned when NOT running as root."
    exit 1;
fi

create_tree

[[ "${USER}" != "root" ]] && modify_uid_gid

