#!/bin/bash

IMAGE_NAME=my-hdl-image

docker build --tag $IMAGE_NAME -f ./dockerfile .