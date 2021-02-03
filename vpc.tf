# create vpc
resource "aws_vpc" "vpc_module" {
    cidr_block = var.vpc_cidr
    instance_tenancy = var.tenancy
    tags = var.tags
}

# create public subnet
resource "aws_subnet" "public" {
    count = local.azs
    vpc_id = aws_vpc.vpc_module.id
    cidr_block = cidrsubnet(var.vpc_cidr, 8, count.index)
    availability_zone = local.azs_names[count.index]
    tags = {
      "Name" = "public-${count.index + 1}"
    }
}
# create internet gateway
resource "aws_internet_gateway" "Inter-IG" {
  vpc_id = aws_vpc.vpc_module.id
  tags = {
    Name = "IG"
  }
}
# create route table
resource "aws_route_table" "route-RT" {
  vpc_id = aws_vpc.vpc_module.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Inter-IG.id
  }
  tags = {
    Name = "route"
  }
}
# create associate public and route table
resource "aws_route_table_association" "a" {
  count = local.azs
  subnet_id      = aws_subnet.public.*.id[count.index]
  route_table_id = aws_route_table.route-RT.id
}