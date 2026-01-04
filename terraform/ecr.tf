resource "aws_ecr_repository" "ecr_repo" {
  name                 = "${var.env_name}-repo"
  image_tag_mutability = "MUTABLE"  # default

  image_scanning_configuration {
    scan_on_push = true
  }

  force_delete = true
}