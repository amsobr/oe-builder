#!/bin/bash
SENTINEL=$1

if [ "$SENTINEL" != "oe-container-sentinel" ]; then
    echo "This container **MUST** be launched with the oe-builder command." 1>&2
    echo "Cowardly refusing to execute." 1>&2
    exit 100
fi

USER_ID=$2

useradd --home-dir /home/oe-builder --create-home \
            --user-group -u $USER_ID --skel /etc/skel --shell /bin/bash oe-builder

cp /opt/oe-builder/.bashrc /home/oe-builder

su -l oe-builder
