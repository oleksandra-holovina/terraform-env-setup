resource "aws_ecs_cluster" "curis_cluster" {
  name = var.name

  tags = {
    Name = var.name
  }
}