# kubeflow

https://www.kubeflow.org/docs/aws/deploy/install-kubeflow/

## Prerequisites

install aws-iam-authenticator (https://docs.aws.amazon.com/eks/latest/userguide/install-aws-iam-authenticator.html)
install eksctl (https://github.com/weaveworks/eksctl)
install kfctl (https://github.com/kubeflow/kfctl/releases/) and untar `tar -xvf kfctl_v1.0.2_linux.tar.gz`
install kubectl 

## Create a Kubeflow Installation on AWS EKS

update deploy_kubeflow_eks.sh:1 to a new EKS cluster name (1 large node will be created to ensure all KF pods can start)
run deploy_kubeflow_eks.sh (takes ~20 mins)

  + after eks cluster is created, the local kubeconfig will be updated to interact with this cluster

Wait for resources to be created (~ 5min): `kubectl get po --all-namespaces -w`

## Access Central Dashboard

kubectl port-forward svc/istio-ingressgateway -n istio-system 8080:80
localhost:8080
