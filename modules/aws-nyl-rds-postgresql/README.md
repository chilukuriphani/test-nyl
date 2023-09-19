# NYL RDS PostgreSQL on AWS

Terraform Module to deploy RDS PostgreSQL database to a NYL AWS account.

## Terraform versions

Terraform 0.12.x

## Usage

```hcl
module "database" {
  source                = "ptfe.nylcloud.com/Cloud-Management/nyl-rds-postgresql/aws"
  app_env               = "${var.app_env}"
  csg_env               = "${var.csg_env}"
  application           = "${var.application}"
  identifier            = "${var.app_env}"
  lob                   = "${var.lob}"
  appid                 = "${var.appid}"
  component             = ""
  project               = "${var.project}"
  engine_version        = "${var.engine_version}"
  instance_class        = "${var.db_instance_class}"
  password              = "${random_password.db_pass.result}"
  skip_final_snapshot   = "${var.skip_final_snapshot}"
  username              = "${var.db_username}"
  allocated_storage     = "${var.allocated_storage}"
  vpc_security_group_id = "${data.aws_security_group.db.id}"
}
```

## Notes
