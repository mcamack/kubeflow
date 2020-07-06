export AWS_CLUSTER_NAME=KF4

# eksctl create cluster --name=${AWS_CLUSTER_NAME} --nodes=1 --node-type=c5.4xlarge --version=1.15 --region=us-west-2
export PATH=$PATH:"/home/matt/kf/kfctl"
export KF_NAME=${AWS_CLUSTER_NAME}
export BASE_DIR=/home/matt/kf
export KF_DIR=${BASE_DIR}/${KF_NAME}
export CONFIG_URI="https://raw.githubusercontent.com/kubeflow/manifests/v1.0-branch/kfdef/kfctl_aws.v1.0.2.yaml"
mkdir -p ${KF_DIR}
cd ${KF_DIR}
wget -O kfctl_aws.yaml $CONFIG_URI
export CONFIG_FILE=${KF_DIR}/kfctl_aws.yaml

#### Update $CONFIG_FILE
sed -i'.bak' -e 's/kubeflow-aws/'"$AWS_CLUSTER_NAME"'/' ${CONFIG_FILE}
NODE_INSTANCE_ROLE=$(aws iam list-roles \
    | jq -r ".Roles[] \
    | select(.RoleName \
    | startswith(\"eksctl-$AWS_CLUSTER_NAME\") and contains(\"NodeInstanceRole\")) \
    .RoleName")
# Update nodegroup role in CONFIG_FILE with the output of the command above
sed -i'.bak' -e 's/eksctl-.*-xxxxxxx/'"$NODE_INSTANCE_ROLE"'/' $CONFIG_FILE

# ## Deploy Kubeflow
cd ${KF_DIR}
kfctl apply -V -f ${CONFIG_FILE}
