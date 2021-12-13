#!/usr/bin/env bats
load "helpers/tests"
load "helpers/docker"
load "helpers/dataloaders"

load "lib/batslib"
load "lib/output"

export BATS_PHP_VERSION="${PHP_VERSION:-7.4.26}"

export BATS_PHP_DOCKER_IMAGE_NAME="${PHP_DOCKER_IMAGE_NAME:-docker.io/elasticms/web2ems:latest}"

@test "[$TEST_FILE] Starting LAMP stack services (apache,mysql,php)" {
  run docker run --rm ${BATS_PHP_DOCKER_IMAGE_NAME} -v
  assert_output -l -r "^PHP ${BATS_PHP_VERSION} \(cli\) \(.*\) \( NTS \)"
}
