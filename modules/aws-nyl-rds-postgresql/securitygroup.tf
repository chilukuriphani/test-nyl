resource "aws_security_group" "rds_postgres" {
  name        = "${var.lob}-${var.env}-${var.application}-rds-postgress-sg"
  description = "Allow traffic to Postgress RDS"
  vpc_id      = data.aws_vpc.default.id
  tags = {
    appid          = var.appid
    cloud_provider = var.cloud_provider
    lob            = var.lob
    env            = var.env
    project        = var.project
    platform       = var.platform
  }
}
resource "aws_vpc_security_group_ingress_rule" "rds_postgress_ingress" {
  security_group_id = aws_security_group.rds_postgres.id
  cidr_ipv4   = data.aws_vpc.default.cidr_block
  from_port   = var.port
  ip_protocol = "tcp"
  to_port     = var.port
}