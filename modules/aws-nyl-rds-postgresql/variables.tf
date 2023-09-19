###############################################################################
#  Terraform Variables file for RDSMODULE
#
#  Version      :       1.0
#  Date         :       01/11/2018
#  Prepared by  :       Devops Team
#  Company      :       New York Life Insurance
#
#  This file declares variables used in main.tf file
#  Comments are enclosed in a hash (#).Everything outside is a valid variable.
#
################################################################################

# Application Line of Business
variable "lob" {
  type = string
}

variable "loned_lob" {
  type = string
  default = "iapasinteg"
  description = "Line of Business where AWS account belongs to"
}

# Application Environment
variable "env" {
  type = string
}

# AWS provider
variable "cloud_provider" {
  type    = string
  default = "aws"
}

# Application Name
variable "application" {
  type = string
}

# Application Id
variable "appid" {
  type = string
}

# Data Type
variable "datatype" {
  type    = string
  default = "n/a"
}

# Application Project Name
variable "project" {
  type = string
}

# Application Platform
variable "platform" {
  type    = string
  default = "microservices"
}

variable "identifier" {
  description = "The name of the database to create when the DB instance is created"
  type        = string
}

variable "username" {
  description = "Username for the master DB user"
  type        = string
}

variable "password" {
  description = "Password for the master DB user"
  type        = string
}

variable "port" {
  description = "Port to run database on"
  type        = string
  default     = "5432"
}

variable "multi_az" {
  description = "Set to true if multi AZ deployment must be supported"
  default     = "true"
}

variable "storage_type" {
  description = "One of 'standard' (magnetic), 'gp2' (general purpose SSD), or 'io1' (provisioned IOPS SSD)."
  default     = "gp3"
}

variable "storage_encrypted" {
  description = "(Optional) Specifies whether the DB instance is encrypted. The default is false if not specified."
  default     = "true"
}

variable "iops" {
  description = "The amount of provisioned IOPS. Setting this implies a storage_type of 'io1'. Default is 0 if rds storage type is not 'io1'"
  default     = "3000"
}

variable "allocated_storage" {
  description = "The allocated storage in GBs"
  default     = "50"
  type        = string
}

variable "max_allocated_storage" {
  description = "The Maximum allocated storage in GBs for auto scaling"
  default     = "100"
  type        = string
}

variable "engine" {
  description = "Database engine type"
  type        = string
  default     = "postgres"
}

variable "engine_version" {
  description = "Database engine version, depends on engine type"
  type        = string
  default     = "9.5.10"
}

variable "instance_class" {
  description = "Class of RDS instance"
  type        = string
  default     = "db.r4.large"
}

variable "auto_minor_version_upgrade" {
  description = "Allow automated minor version upgrade"
  default     = "true"
  type        = string
}

variable "allow_major_version_upgrade" {
  description = "Allow major version upgrade"
  default     = "false"
  type        = string
}

variable "apply_immediately" {
  description = "Specifies whether any database modifications are applied immediately, or during the next maintenance window"
  default     = "false"
  type        = string
}

variable "maintenance_window" {
  description = "The window to perform maintenance in. Syntax: 'ddd:hh24:mi-ddd:hh24:mi' UTC "
  default     = "Sun:09:00-Sun:11:59"
  type        = string
}

variable "backup_retention_period" {
  description = "Backup retention period in days. Must be > 0 to enable backups"
  default     = 1
}

variable "backup_window" {
  description = "When AWS can perform DB snapshots, can't overlap with maintenance window"
  default     = "00:30-05:30"
  type        = string
}

variable "skip_final_snapshot" {
  type    = string
  default = "false"
}

variable "snapshot_identifier" {
  description = "DB snapshot to create this database from"
  type        = string
  default     = ""
}

variable "family" {
  description = "DB family for parameter group"
  type        = string
  default     = "postgres10"
}

variable "rotate_days" {
  description = "The number of days between password rotations"
  type        = string
  default     = "180"
}
variable "cloudaware_scheduler" {
  description = "Default instance work hours managed by cloudaware"
  type        = string
  default     = "default=on"
}
variable "ca_cert_identifier" {
  description = "The identifier of the CA certificate"
  type        = string
  default     = "rds-ca-rsa2048-g1"
}