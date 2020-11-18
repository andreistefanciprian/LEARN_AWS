variable "region" {
  default = "us-east-1"
}

variable "cloud_assume_role" {
  type    = bool
  default = true
}

variable "extenal_id" {
  type    = string
  default = "smth"
}

variable "session_name" {
  type    = string
  default = "Jenkins"
}

variable "session_duration" {
  type    = number
  default = 3600
}

variable "aws_account" {
  type    = string
  default = "12345678910"
}



