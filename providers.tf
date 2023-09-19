terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.16.1"
    }
    postgresql = {
      source  = "cyrilgdn/postgresql"
      version = "1.21.0"
    }
  }
}

provider "aws" {
  region = var.region
/*  assume_role {
    role_arn    = var.assume_role_arn
    external_id = var.external_id
  }
*/
  default_tags {
    tags = {
      appid = var.appid
    }
  }
}

provider "postgresql" {
  host     = "be-dev-db-postgresql.co9dh8tdl1f4.us-east-1.rds.amazonaws.com"
  port     = 5432
  database = "be"
  username = "postgres"
  password = "zXpYZL9suAUpl27c"
  connect_timeout = 120
  superuser       = false
}
