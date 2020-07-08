#!/bin/bash -e
aws ecr get-login-password --region us-west-2 | docker login --username AWS --password-stdin 034557894042.dkr.ecr.us-west-2.amazonaws.com

ecr_url=034557894042.dkr.ecr.us-west-2.amazonaws.com # Specify the image name here
ecr_repo_name=kubeflow
image_tag=conda_tfx
full_image_name=${ecr_url}/${ecr_repo_name}:${image_tag}

cd "$(dirname "$0")" 
docker build -t "${ecr_repo_name}" .
docker tag "${ecr_repo_name}:${image_tag}" "${full_image_name}"
docker push "${full_image_name}"

# Output the strict image name (which contains the sha256 image digest)
docker inspect --format="{{index .RepoDigests 0}}" "${full_image_name}"
