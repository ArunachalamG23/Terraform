variable "cidr" {
  default = "5.0.0.0/20"
}
variable "public_subnet_cidr" {
  type    = list(string)
  default = ["5.0.1.0/24", "5.0.2.0/24", "5.0.3.0/24"]
}
variable "private_subnet_cidr" {
  type    = list(string)
  default = ["5.0.4.0/24", "5.0.5.0/24", "5.0.6.0/24"]
}
variable "availability_zone" {
  type    = list(string)
  default = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
} 