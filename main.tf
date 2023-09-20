resource "random_password" "db_pass" {
  length  = 16
  special = false
}

module "database" {
  source                = "./modules/aws-nyl-rds-postgresql"
  env                   = var.env
  application           = var.application
  identifier            = "${var.lob}-${var.env}-db-postgresql"
  lob                   = var.lob
  appid                 = var.appid
  project               = var.project
  engine_version        = var.engine_version
  instance_class        = var.db_instance_class
  password              = random_password.db_pass.result
  skip_final_snapshot   = var.skip_final_snapshot
  username              = var.db_username
  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage
  allow_major_version_upgrade = var.allow_major_version_upgrade
  apply_immediately     = var.apply_immediately
  family                = var.db_family
  auto_minor_version_upgrade = var.auto_minor_version_upgrade
  multi_az              = var.multi_az
  cloudaware_scheduler  = var.cloudaware_scheduler
}

data "postgresql_tables" "my_tables" {
  database = "be"
}
/*
output "db_tables" {
  value = "${data.postgresql_tables.my_tables.tables}"
}
*/

resource "postgresql_role" "my_replication_user" {
  name             = "beuser"
  login            = true
  connection_limit = 1
  password         = "md5c98cbfeb6a347a47eb8e96cfb4c4b890"
//  roles            = ["LOGIN"]
}