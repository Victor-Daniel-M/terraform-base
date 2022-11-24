#!/bin/bash

output=$(aws ecr describe-repositories --repository-names "${IMAGE_NAME}" 2>&1)

if [ $? -ne 0 ]; then
  if echo "${output}" | grep -q RepositoryNotFoundException; then
    aws ecr create-repository --repository-name "${IMAGE_NAME}" | jq .repository.repositoryUri -r
  else
    echo >&2 "${output}"
  fi
else
  echo "${output}" | jq .repositories[].repositoryUri -r
fi
