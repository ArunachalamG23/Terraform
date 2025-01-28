module "ec2_instance" {
  source        = "../modules/EC2"
  ami_id        = "ami-0368b2c10d7184bc7"
  instance_type = "t3.micro"
  subnet_id     = "subnet-0ce730e42daf43c71"
}