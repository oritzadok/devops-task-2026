output "aws_region" {
  value = var.aws_region
}

output "eks_cluster" {
  value = aws_eks_cluster.cluster.name
}

#output "app_url" {
#  value = 
#}