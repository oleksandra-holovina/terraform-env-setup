resource "aws_ecs_cluster" "curis-cluster" {
  name = var.name

  tags = {
    Name = var.name
  }
}