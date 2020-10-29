#!/bin/bash

H2O_VER=3.30.0.1

echo "Building image with H2O Version ${H2O_VER}"
docker build . -t cloudberry/h2o-arm64 --platform linux/arm64 --build-arg H2O_VERSION=${H2O_VER}
echo "DONE!"

