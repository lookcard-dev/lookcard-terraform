module "hello-world" {
  source              = "./helloworld"
  vpc_id              = var.network.vpc
  ecs_cluster_id      = aws_ecs_cluster.look_card.id
  private_subnet_list = var.network.private_subnet_ids
  alb_arn             = aws_alb.look-card.arn
}
