data "aws_availability_zones" "available" {
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

# data "kubernetes_service" "argocd" {
#   metadata {
#     name      = "argo-cd-argocd-server"
#     namespace = "argocd"
#   }
# }
