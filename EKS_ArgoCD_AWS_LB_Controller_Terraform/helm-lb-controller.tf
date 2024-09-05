resource "helm_release" "aws_load_balancer_controller" {
  provider         = kubernetes
  name             = "aws-load-balancer-controller"
  repository       = "https://aws.github.io/eks-charts"
  chart            = "aws-load-balancer-controller"
  version          = "1.4.1"
  namespace        = "aws-loadbalancer-controller"
  create_namespace = true
  set {
    name  = "clusterName"
    value = "k8s-cluster"
  }

  set {
    name  = "serviceAccount.create"
    value = "true"
  }

  set {
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  }

  depends_on = [
    kubernetes_service_account.lb-controller,
  ]
}
