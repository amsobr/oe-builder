#!/bin/bash
SENTINEL=$1

if [ "$SENTINEL" != "oe-container-sentinel" ]; then
    echo "This container **MUST** be launched with the oe-builder command." 1>&2
    echo "Cowardly refusing to execute." 1>&2
    exit 100
fi

USER_ID=$2
GROUP_ID=$3

groupadd -g $GROUP_ID oe-builder
useradd --home-dir /home/oe-builder --create-home \
            -g oe-builder -u $USER_ID --skel /etc/skel --shell /bin/bash oe-builder

cp /opt/oe-builder/.bashrc /home/oe-builder
ln -s /tmp/_ssh /home/oe-builder/.ssh
ln -s /tmp/_bash_history /home/oe-builder/.bash_history

su -l oe-builder
