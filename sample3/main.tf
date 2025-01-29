provider "aws" {
  region = "eu-north-1"
}
resource "aws_instance" "ec2" {
  instance_type = "t3.micro"
  ami        = "ami-0368b2c10d7184bc7"
  subnet_id     = "subnet-0a7d4a17dd34a7d2e"
}
resource "aws_s3_bucket" "s3" {
  bucket = "terraform07"
}
resource "aws_dynamodb_table" "terraform_lock" {
  name         = "terraform_lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}