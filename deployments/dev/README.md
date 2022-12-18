# EKS Cluster Deployment with new VPC

This example deploys the following Basic EKS Cluster with VPC

- Creates a new sample VPC, 3 Private Subnets and 3 Public Subnets
- Creates Internet gateway for Public Subnets and NAT Gateway for Private Subnets
- Creates EKS Cluster Control plane with one managed node group

## How to Deploy

### Prerequisites

Ensure that you have installed the following tools in your Mac or Windows Laptop before start working with this module and run Terraform Plan and Apply

1. [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)
2. [Kubectl](https://Kubernetes.io/docs/tasks/tools/)
3. [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)

### Deployment Steps

Details for how to initialize the TF provider can be found [here](https://blog.gruntwork.io/how-to-manage-terraform-state-28f5697e68fa)

Note. Detailed steps to initialize this can be found [here](https://aws-ia.github.io/terraform-aws-eks-blueprints/getting-started/)

## Using ArgoCD CLI

```bash
# Forwarding Ports to Access Argo CD
kubectl port-forward svc/argo-cd-argocd-server -n argocd 8080:443

# Copy password to clipboard
ARGOCD_PASSWORD=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)

argocd login localhost:8080 --username admin --password $ARGOCD_PASSWORD
```

### Example using CLI to create application

```bash
argocd app create test-application \
  --upsert \
  --repo https://github.com/jake-dhcs/sample-eks-with-argo \
  --path applications \
  --revision main \
  --project argocd-demo \
  --auto-prune \
  --sync-policy automatic \
  --dest-namespace argocd-demo \
  --dest-name in-cluster
```

## Cleanup

To clean up your environment, destroy the Terraform modules in reverse order.

Destroy the Kubernetes Add-ons, EKS cluster with Node groups and VPC.

Note, you may need to manually destroy any load balancers which were created to expose the argo application.

```sh
terraform destroy -target="module.eks_blueprints_kubernetes_addons" -auto-approve
terraform destroy -target="module.eks_blueprints" -auto-approve
terraform destroy -target="module.vpc" -auto-approve
```

Finally, destroy any additional resources that are not in the above modules

```sh
terraform destroy -auto-approve
```
