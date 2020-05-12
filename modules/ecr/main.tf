resource "aws_ecr_repository" "curis_ecr" {
  name                 = var.name
  image_tag_mutability = var.image_tag_mutability

  tags = {
    Name = var.name
  }
}