resource "aws_cloudwatch_log_group" "app" {
  name              = "/ecs/dnyanarambh"
  retention_in_days = 7

  tags = {
    Name = "dnyanarambh-ecs-logs"
  }
}
