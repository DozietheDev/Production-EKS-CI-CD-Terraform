resource "aws_ecr_repository" "this" {
  name                 = var.repository
  image_tag_mutability = "MUTABLE"
  force_delete         = var.force_delete

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "${var.repository}-repo"
  }
}
