# Base Docker image [![Docker Build](https://github.com/ems-project/docker-php-cli/actions/workflows/docker-build.yml/badge.svg?branch=8.0)](https://github.com/ems-project/docker-php-cli/actions/workflows/docker-build.yml)

Docker base image is the basic image on which you add layers (which are basically filesystem changes) and create a final image containing your App.  

```
set -a
source .build.env
set +a

docker build --build-arg VERSION_ARG=${PHP_VERSION} \
             --build-arg AWS_CLI_VERSION_ARG=${AWS_CLI_VERSION} \
             --build-arg NODE_VERSION_ARG=${NODE_VERSION} \
             --build-arg RELEASE_ARG=snapshot \
             --build-arg BUILD_DATE_ARG="" \
             --build-arg VCS_REF_ARG="" \
             --target php-cli-prod \
             -t ${PHPCLI_PRD_DOCKER_IMAGE_NAME}:latest .

docker build --build-arg VERSION_ARG=${PHP_VERSION} \
             --build-arg AWS_CLI_VERSION_ARG=${AWS_CLI_VERSION} \
             --build-arg NODE_VERSION_ARG=${NODE_VERSION} \
             --build-arg RELEASE_ARG=snapshot \
             --build-arg BUILD_DATE_ARG="" \
             --build-arg VCS_REF_ARG="" \
             --target php-cli-dev \
             -t ${PHPCLI_DEV_DOCKER_IMAGE_NAME}:latest .

```
