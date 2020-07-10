#!/bin/bash

IMAGE_NAME=my-hdl-image
DOCKER_BASHRC=/tmp/.docker_${USER}_bashrc
PWD=$(pwd)

echo "> Entering docker container"
APP=${@:-/bin/bash}

rm -rf ${DOCKER_BASHRC} 2>/dev/null
cp ${HOME}/.bashrc ${DOCKER_BASHRC} 2>/dev/null
echo -e "\nPS1=\"(hdl-image) \$PS1\"" >> ${DOCKER_BASHRC}

docker run \
    -v ${DOCKER_BASHRC}:${HOME}/.bashrc \
    -v ${PWD}:/home \
    --net=host \
    -w /home \
    -it \
    $IMAGE_NAME \
    $APP

echo "> Exit"
