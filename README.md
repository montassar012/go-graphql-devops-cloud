# Capstone Project  for  Udacity Cloud DevOps Nanodegree


In this project we will apply the skills and knowledge which were developed throughout the Cloud DevOps Nanodegree program. These include:

- Working in AWS
- Using Jenkins to implement Continuous Integration and Continuous Deployment
- Working with Ansible and CloudFormation to deploy clusters
- Building Kubernetes clusters
- Building pipelines
- Building Docker containers in pipelines



We will develop a CI/CD pipeline for micro services application with rolling deployment.

We will develop  a  basic Graphql  app  using golang language and dockerize it. 
Finally we will deploy this in a kubernetes cluster with 4 worker nodes and Loadbalancer  service in AWS. We will use jenkins for the CI/CD to deploy the infrastructure in AWS ( using  ansible and Cloudformation). We will also develop the Continuous Integration steps like linting. Finally as post deployment steps, we will perform additional testing by Jenkins whether the app is up and running, check whether it got successfully rolled out and also clean up the docker environment.


# AWS Elastic Kubernetes Service: a cluster creation automation



We will use :
-  Ansible: to automate CloudFormation stack creation and to execute eksctl with necessary parameters.

- CloudFormation with NestedStacks: to create an infrastructure – VPC, subnets, SecurityGroups, IAM-roles,...

- eksctl: to create a cluster itself using resources created by CloudFormation


1 - Ansible will use the cloudformation module to create an  infrastructure
then by using Outputs of the stack created by CloudFormation. 
2 - Ansible will generate a config file for the eksctl.
3 - Ansible calls eksctl passing the config-file and will create a cluster


## the CloudFormation stack.

We need to create:

1 VPC
two public subnets for Application Load Balancers, Bastion hosts, Internet Gateways
two private subnets for Kubernetes Worker Nodes EC2, NAT Gateways
EKS AMI for Kubernetes Worker Nodes eksctl will choose automatically