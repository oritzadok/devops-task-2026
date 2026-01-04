# Ingress controller
resource "helm_release" "aws_lb_controller" {
  name       = "aws-load-balancer-controller"
  namespace  = "kube-system"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"

  set = [
    {
      name  = "region"
      value = var.aws_region
    },
    {
      name  = "clusterName"
      value = aws_eks_cluster.cluster.name
    },
    {
      name  = "serviceAccount.create"
      value = "true"
    },
    {
      name  = "serviceAccount.name"
      value = "aws-load-balancer-controller"
    },
    {
      name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
      value = aws_iam_role.alb_controller.arn
    }
  ]

  depends_on = [
    aws_eks_node_group.node_group,
    aws_iam_role_policy_attachment.alb_controller,
    aws_eks_addon.cloudwatch_observability
  ]
}


resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  create_namespace = true

  # To expose Argo CD API server with an external IP
  set = [
    {
      name  = "server.service.type"
      value = "LoadBalancer"
    }
  ]

  depends_on = [
    helm_release.aws_lb_controller
  ]
}