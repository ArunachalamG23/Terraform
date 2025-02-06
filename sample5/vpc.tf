resource "aws_vpc" "testvpc" {
  cidr_block = var.cidr
  tags = {
    Name = "vpc-1"
  }
}
resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.testvpc.id
  count             = length(var.public_subnet_cidr)
  cidr_block        = element(var.public_subnet_cidr, count.index)
  availability_zone = element(var.availability_zone, count.index)
  tags = {
    Name = "public_subnet-${count.index + 1}"
  }
}
resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.testvpc.id
  count             = length(var.private_subnet_cidr)
  cidr_block        = element(var.private_subnet_cidr, count.index)
  availability_zone = element(var.availability_zone, count.index)
  tags = {
    Name = "private_subnet-${count.index + 1}"
  }
}
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.testvpc.id
  tags = {
    Name = "Test-IGW"
  }
}
resource "aws_route_table" "RT" {
  vpc_id = aws_vpc.testvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id 
  }
  tags = {
    Name = "public RT"
  }
}
resource "aws_route_table_association" "public_sub" {
  count          = length(var.public_subnet_cidr)
  subnet_id      = element(aws_subnet.public_subnet[*].id, count.index)
  route_table_id = aws_route_table.RT.id
}
