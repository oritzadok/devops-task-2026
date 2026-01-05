# To determine VPC ID
data "aws_subnet" "subnet1" {
  id = var.subnet_ids[0]
}

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
      name  = "vpcId"
      value = data.aws_subnet.subnet1.vpc_id
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

  depends_on = [
    aws_eks_node_group.node_group
  ]
}