# =============== Global variables ===============

variable "region" {
  type    = string
  default = "us-east-1"
}


variable "application" {
  type    = string
  default = "be"
}

variable "platform" {
  type    = string
  default = "insure"
  description = "Platform"
}
/*
variable "assume_role_arn" {
  type = string
}

variable "external_id" {
  type = string
}
*/
variable "project" {
  type    = string
  default = "be"
  description = "Project"
}

variable "appid" {
  type    = string
  default = "APP-696"
  description = "App ID"
}

variable "lob" {
  type = string
  default = "be"
  description = "Line of Business"
}

variable "env" {
  type = string
  description = "Environment"
  default = "dev"
}

variable "cloud_provider" {
  type    = string
  default = "aws"
  description = "Cloud Provider"
}


# =============== database variables ===============

variable "engine_version" {
  description = "Database engine version, depends on engine type"
  type        = string
  default     = "15.3"
}

variable "db_instance_class" {
  description = "Class of RDS instance"
  type        = string
  default     = "db.t3.micro"
}

variable "skip_final_snapshot" {
  type    = string
  default = "false"
}

variable "db_username" {
  description = "Username for the master DB user"
  type        = string
  default     = "postgres"
}

variable "allocated_storage" {
  description = "The allocated storage in GBs"
  type        = string
  default     = "50"
}

variable "max_allocated_storage" {
  description = "The allocated storage in GBs"
  default     = "100"
  type        = string
}

variable "allow_major_version_upgrade" {
  description = "Allow major version upgrade"
  default     = "true"
  type        = string
}

variable "auto_minor_version_upgrade" {
  description = "Allow automated minor version upgrade"
  default     = "false"
  type        = string
}

variable "multi_az" {
  description = "Set to true in workspace variable if multi AZ deployment must be supported"
  default = false
  type = string
}


variable "apply_immediately" {
  description = "Set to true if need to update the setting immediately"
  type      = string
  default   = "true"
}

variable "db_family" {
  description = "Set to true if need to update the setting immediately"
  type      = string
  default   = "postgres15"
}

variable "cloudaware_scheduler" {
  description = "Default instance work hours managed by cloudaware"
  type        = string
  default     = "default=on"
}