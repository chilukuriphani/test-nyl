data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_vpc" "default" {
  filter {
    name   = "tag:Name"
   # values = ["nyl-${var.loned_lob}-${var.env}-vpc"]
    values = ["default"]
  }
}

data "aws_subnets" "data" {
  filter {
    name = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
/*  tags = {
    tier = "data"
  }
  */
}

data "aws_subnets" "compute" {
  filter {
    name = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
  /*
  tags = {
    tier = "compute"
  }
  */
}

/*
data "aws_security_group" "default" {
  name = "nyl-${var.lob}-${var.env}-vpc-access-sg"
}

data "aws_kms_alias" "kms_alias" {
#  name = "alias/nyl-${var.lob}-${var.env}-cmk"
  name = "alias/aws/s3"
}
*/
resource "aws_db_subnet_group" "db" {
  name       = "${var.lob}-${var.env}-${var.application}-db-sg"
  subnet_ids = data.aws_subnets.data.ids
}

resource "aws_db_parameter_group" "parameter_group" {
  name   = "${var.lob}-${var.env}-${var.application}-pg"
  family = var.family

  parameter {
    name         = "rds.force_ssl"
    value        = "1"
    apply_method = "pending-reboot"
  }
}

resource "aws_lambda_function" "rotate" {
  function_name    = "${var.lob}-${var.env}-rotate-rds-password-fn"
  description      = "Rotate RDS Password"
  filename         = "${path.module}/rotate_password.zip"
  role             = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.lob}-${var.env}-lambda-rds-rotate-role"
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.7"
  timeout          = "60"
  source_code_hash = base64sha256(filebase64("${path.module}/rotate_password.zip"))

  environment {
    variables = {
      SECRETS_MANAGER_ENDPOINT = "https://secretsmanager.${data.aws_region.current.name}.amazonaws.com"
    }
  }

  vpc_config {
    security_group_ids = [aws_security_group.rds_postgres.id]
    subnet_ids         = data.aws_subnets.compute.ids
  }

  lifecycle {
    ignore_changes = [
      source_code_hash
    ]
  }
}

resource "aws_lambda_permission" "allow_secret_manager_call_Lambda" {
  function_name = aws_lambda_function.rotate.function_name
  statement_id  = "AllowExecutionSecretManager"
  action        = "lambda:InvokeFunction"
  principal     = "secretsmanager.amazonaws.com"
}

resource "aws_db_instance" "default" {
  identifier                  = var.identifier
  db_name                     = var.application
  username                    = var.username
  password                    = var.password
  port                        = var.port
  engine                      = var.engine
  engine_version              = var.engine_version
  instance_class              = var.instance_class
  allocated_storage           = var.allocated_storage
  storage_encrypted           = var.storage_encrypted
 # kms_key_id                  = replace(data.aws_kms_alias.kms_alias.arn, data.aws_kms_alias.kms_alias.name, "key/${data.aws_kms_alias.kms_alias.target_key_id}")
  kms_key_id                  = aws_kms_key.rds_kms.arn
  db_subnet_group_name        = aws_db_subnet_group.db.name
  parameter_group_name        = aws_db_parameter_group.parameter_group.name
  multi_az                    = var.multi_az
  storage_type                = var.storage_type
  iops                        = var.iops
  publicly_accessible         = "false"
  snapshot_identifier         = var.snapshot_identifier
  allow_major_version_upgrade = var.allow_major_version_upgrade
  auto_minor_version_upgrade  = var.auto_minor_version_upgrade
  apply_immediately           = var.apply_immediately
  maintenance_window          = var.maintenance_window
  skip_final_snapshot         = var.skip_final_snapshot
  backup_retention_period     = var.backup_retention_period
  backup_window               = var.backup_window
  final_snapshot_identifier   = "${var.identifier}-final-snapshot"
  vpc_security_group_ids      = [aws_security_group.rds_postgres.id]
  max_allocated_storage       = var.max_allocated_storage
  ca_cert_identifier          = var.ca_cert_identifier
  tags = {
    Name           = var.identifier
    appid          = var.appid
    cloud_provider = var.cloud_provider
    lob            = var.lob
    env            = var.env
    project        = var.project
    platform       = var.platform
    "cloudaware:scheduler" = var.cloudaware_scheduler    
  }
}

resource "aws_secretsmanager_secret" "db_secretmanager_secret" {
  name                = "${var.lob}-${var.env}-db-postgresql-secret"
#  kms_key_id          = replace(data.aws_kms_alias.kms_alias.arn, data.aws_kms_alias.kms_alias.name, "key/${data.aws_kms_alias.kms_alias.target_key_id}")
  kms_key_id          = aws_kms_key.rds_kms.id
}

resource "aws_secretsmanager_secret_rotation" "db_secretmanager_rotation" {
  secret_id           = aws_secretsmanager_secret.db_secretmanager_secret.id
  rotation_lambda_arn = aws_lambda_function.rotate.arn

  rotation_rules {
    automatically_after_days = var.rotate_days
  }
}

resource "aws_secretsmanager_secret_version" "example" {
  secret_id = aws_secretsmanager_secret.db_secretmanager_secret.id
  secret_string = jsonencode({ "engine" = aws_db_instance.default.engine,
    "password" = aws_db_instance.default.password,
    "username" = aws_db_instance.default.username,
    "db_name"  = aws_db_instance.default.db_name,
    "port"     = aws_db_instance.default.port,
    "host"     = aws_db_instance.default.address })
}
