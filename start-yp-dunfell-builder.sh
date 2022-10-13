#!/bin/bash

REV=2
USER_NAME=$(whoami)
USER_ID=$(id -u)
HOST_DATADIR=$(pwd)/data
CONTAINER_DATADIR=/data
YP_RELEASE=dunfell

DATA_DIR=data
IMAGE_NAME=yp-builder-$YP_RELEASE-$USER_NAME:$REV

TMP_DOCKERFILE=$(mktemp)
cat > $TMP_DOCKERFILE << EOF
FROM ubuntu:18.04

ARG USER_ID

RUN apt-get -y update && \
apt-get -y full-upgrade && \
apt-get -y install \
      gawk \
      wget \
      git-core \
      subversion \
      diffstat \
      unzip \
      sysstat \
      texinfo \
      build-essential \
      chrpath \
      socat \
      python \
      python3 \
      xz-utils  \
      locales \
      cpio \
      screen \
      tmux \
      sudo \
      iputils-ping \
      iproute2 \
      fluxbox \
      tightvncserver \
      liblz4-tool \
      zstd \
      bash-completion

RUN apt-get -y clean
RUN usermod -p "" root

RUN useradd --home-dir /home/$USER_NAME --create-home \
            --user-group -u \$USER_ID --skel /etc/skel --shell /bin/bash $USER_NAME



USER $USER_NAME
WORKDIR /data
ENV HOME /home/$USER_NAME
CMD ["/bin/bash","-i"]

EOF

if [ ! -d $DATA_DIR ]; then
    echo "'$DATA_DIR' directory is missing or container started from the wrong location."
    exit 1
fi

echo -n "Checking if ${IMAGE_NAME} is loaded..."
if docker image inspect ${IMAGE_NAME} > /dev/null 2>&1; then
    echo "looks good!"
else
    echo "nope!"
    echo "Generating image for current user..."
    # build with --no-cache to ensure clean build
    docker build --tag ${IMAGE_NAME} --build-arg USER_ID=$USER_ID -f $TMP_DOCKERFILE .
fi

echo "NOTE: bound directories between host and container:"
echo "    Directory on Host      --> $HOST_DATADIR"
echo "    Directory in container --> $CONTAINER_DATADIR"
echo "    Data in this directory is persistent!"


docker run --hostname "yp-builder" --user $USER_ID:$USER_ID \
        --init --rm \
        --mount type=bind,source="$HOST_DATADIR",target=$CONTAINER_DATADIR -it \
        ${IMAGE_NAME}
 
exit

