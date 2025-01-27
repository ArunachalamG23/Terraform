resource "aws_instance" "sample" {
  ami           = var.ami
  instance_type = var.instance_id
  subnet_id     = var.subnet_id
}