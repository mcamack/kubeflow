# kubeflow
https://www.kubeflow.org/docs/aws/deploy/install-kubeflow/

## Create EKS Cluster
install eksctl (https://github.com/weaveworks/eksctl)
eksctl create cluster --name=KF3 --nodes=1 --node-type=c5.4xlarge --version=1.15 --region=us-west-2

## Install aws-iam-authenticator
https://docs.aws.amazon.com/eks/latest/userguide/install-aws-iam-authenticator.html

## Install kfctl cli tool:
Download the kfctl v1.0.2 release from the Kubeflow releases page (https://github.com/kubeflow/kfctl/releases/)
tar -xvf kfctl_v1.0.2_linux.tar.gz

## Create environment variables for deployment process:
export PATH=$PATH:"/home/matt/kf/kfctl"
export AWS_CLUSTER_NAME=KF3
export KF_NAME=${AWS_CLUSTER_NAME}
export BASE_DIR=/home/matt/kf
export KF_DIR=${BASE_DIR}/${KF_NAME}

#### Use the following kfctl configuration file for the AWS setup without authentication:
export CONFIG_URI="https://raw.githubusercontent.com/kubeflow/manifests/v1.0-branch/kfdef/kfctl_aws.v1.0.2.yaml"

#### Alternatively, if you want to enable authentication, authorization and multi-user:
#export CONFIG_URI="https://raw.githubusercontent.com/kubeflow/manifests/v1.0-branch/kfdef/kfctl_aws_cognito.v1.0.2.yaml"

## Setup Kubeflow Config:
mkdir -p ${KF_DIR}
cd ${KF_DIR}
wget -O kfctl_aws.yaml $CONFIG_URI
export CONFIG_FILE=${KF_DIR}/kfctl_aws.yaml

#### Update $CONFIG_FILE
sed -i'.bak' -e 's/kubeflow-aws/'"$AWS_CLUSTER_NAME"'/' ${CONFIG_FILE}
Update nodegroup role with the output of this cmd:
aws iam list-roles \
    | jq -r ".Roles[] \
    | select(.RoleName \
    | startswith(\"eksctl-$AWS_CLUSTER_NAME\") and contains(\"NodeInstanceRole\")) \
    .RoleName"

## Deploy Kubeflow
cd ${KF_DIR}
kfctl apply -V -f ${CONFIG_FILE}

Wait for resources to be created:
kubectl -n kubeflow get all

## Access Central Dashboard:
kubectl port-forward svc/istio-ingressgateway -n istio-system 8080:80
localhost:8080
