variable "region" {
  default = "us-east-1"
}
variable "vpc_cidr" {
  default = "10.0.1.0/16"
}
variable "tenancy" {
  default = "default"
}
variable "tags" {
  default = {
      Name = "module"
  }
}
 