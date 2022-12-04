# Base Docker image ![Continuous Docker Image Build](https://github.com/ems-project/docker-php-cli/workflows/Continuous%20Docker%20Image%20Build/badge.svg)

Docker base image is the basic image on which you add layers (which are basically filesystem changes) and create a final image containing your App.  

```
set -a
source .build.env
set +a

docker build --build-arg VERSION_ARG=${PHP_VERSION} \
             --build-arg NODE_VERSION_ARG=${NODE_VERSION} \
             --build-arg RELEASE_ARG=snapshot \
             --build-arg BUILD_DATE_ARG="" \
             --build-arg VCS_REF_ARG="" \
             --target php-cli-prod \
             -t ${PHPCLI_PRD_DOCKER_IMAGE_NAME}:rc .

docker build --build-arg VERSION_ARG=${PHP_VERSION} \
             --build-arg NODE_VERSION_ARG=${NODE_VERSION} \
             --build-arg RELEASE_ARG=snapshot \
             --build-arg BUILD_DATE_ARG="" \
             --build-arg VCS_REF_ARG="" \
             --target php-cli-dev \
             -t ${PHPCLI_DEV_DOCKER_IMAGE_NAME}:rc .

docker build --build-arg VERSION_ARG=${PHP_VERSION} \
             --build-arg NODE_VERSION_ARG=12 \
             --build-arg RELEASE_ARG=snapshot \
             --build-arg BUILD_DATE_ARG="" \
             --build-arg VCS_REF_ARG="" \
             --target php-cli-prod \
             -f Dockerfile.py2-node12 \
             -t ${PHPCLI_PRD_DOCKER_IMAGE_NAME}:rc-py2-node12 .

docker build --build-arg VERSION_ARG=${PHP_VERSION} \
             --build-arg NODE_VERSION_ARG=12 \
             --build-arg RELEASE_ARG=snapshot \
             --build-arg BUILD_DATE_ARG="" \
             --build-arg VCS_REF_ARG="" \
             --target php-cli-dev \
             -f Dockerfile.py2-node12 \
             -t ${PHPCLI_DEV_DOCKER_IMAGE_NAME}:rc-py2-node12 .

docker build --build-arg VERSION_ARG=${PHP_VERSION} \
             --build-arg NODE_VERSION_ARG=13 \
             --build-arg RELEASE_ARG=snapshot \
             --build-arg BUILD_DATE_ARG="" \
             --build-arg VCS_REF_ARG="" \
             --target php-cli-prod \
             -f Dockerfile.py2-node13 \
             -t ${PHPCLI_PRD_DOCKER_IMAGE_NAME}:rc-py2-node13 .

docker build --build-arg VERSION_ARG=${PHP_VERSION} \
             --build-arg NODE_VERSION_ARG=13 \
             --build-arg RELEASE_ARG=snapshot \
             --build-arg BUILD_DATE_ARG="" \
             --build-arg VCS_REF_ARG="" \
             --target php-cli-dev \
             -f Dockerfile.py2-node13 \
             -t ${PHPCLI_DEV_DOCKER_IMAGE_NAME}:rc-py2-node13 .

docker build --build-arg VERSION_ARG=${PHP_VERSION} \
             --build-arg NODE_VERSION_ARG=14 \
             --build-arg RELEASE_ARG=snapshot \
             --build-arg BUILD_DATE_ARG="" \
             --build-arg VCS_REF_ARG="" \
             --target php-cli-prod \
             -f Dockerfile.py2-node14 \
             -t ${PHPCLI_PRD_DOCKER_IMAGE_NAME}:rc-py2-node14 .

docker build --build-arg VERSION_ARG=${PHP_VERSION} \
             --build-arg NODE_VERSION_ARG=14 \
             --build-arg RELEASE_ARG=snapshot \
             --build-arg BUILD_DATE_ARG="" \
             --build-arg VCS_REF_ARG="" \
             --target php-cli-dev \
             -f Dockerfile.py2-node14 \
             -t ${PHPCLI_DEV_DOCKER_IMAGE_NAME}:rc-py2-node14 .

docker build --build-arg VERSION_ARG=${PHP_VERSION} \
             --build-arg NODE_VERSION_ARG=15 \
             --build-arg RELEASE_ARG=snapshot \
             --build-arg BUILD_DATE_ARG="" \
             --build-arg VCS_REF_ARG="" \
             --target php-cli-prod \
             -f Dockerfile.py2-node15 \
             -t ${PHPCLI_PRD_DOCKER_IMAGE_NAME}:rc-py2-node15 .

docker build --build-arg VERSION_ARG=${PHP_VERSION} \
             --build-arg NODE_VERSION_ARG=15 \
             --build-arg RELEASE_ARG=snapshot \
             --build-arg BUILD_DATE_ARG="" \
             --build-arg VCS_REF_ARG="" \
             --target php-cli-dev \
             -f Dockerfile.py2-node15 \
             -t ${PHPCLI_DEV_DOCKER_IMAGE_NAME}:rc-py2-node15 .

docker build --build-arg VERSION_ARG=${PHP_VERSION} \
             --build-arg NODE_VERSION_ARG=15 \
             --build-arg RELEASE_ARG=snapshot \
             --build-arg BUILD_DATE_ARG="" \
             --build-arg VCS_REF_ARG="" \
             --target php-cli-prod \
             -f Dockerfile.py2-node15 \
             -t ${PHPCLI_PRD_DOCKER_IMAGE_NAME}:rc-py2-node15 .

docker build --build-arg VERSION_ARG=${PHP_VERSION} \
             --build-arg NODE_VERSION_ARG=16 \
             --build-arg RELEASE_ARG=snapshot \
             --build-arg BUILD_DATE_ARG="" \
             --build-arg VCS_REF_ARG="" \
             --target php-cli-dev \
             -f Dockerfile.py2-node16 \
             -t ${PHPCLI_DEV_DOCKER_IMAGE_NAME}:rc-py2-node16 .

```
