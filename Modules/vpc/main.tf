resource "aws_vpc" "vpc_terraform" {
    cidr_block = var.vpc_cidr
   
    tags = {
        Name = "vpc-terraform"
    }

}

resource "aws_internet_gateway" "terraform_internet_gateway" {
  vpc_id = aws_vpc.vpc_terraform.id

  tags = {
    Name = "terraform-internet-gateway"
  }
}

resource "aws_subnet" "public" {
  count                   = length(var.vpc_public_subnets)
  vpc_id                  = aws_vpc.vpc_terraform.id
  cidr_block              = var.vpc_public_subnets[count.index]
  availability_zone       = var.vpc_azs[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "Public_subnet_${count.index}"
  }

}

resource "aws_subnet" "private" {
  count                   = length(var.vpc_private_subnets)
  vpc_id                  = aws_vpc.vpc_terraform.id
  cidr_block              = var.vpc_private_subnets[count.index]
  availability_zone       = var.vpc_azs[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "Private_subnet_${count.index}"
  }
}

resource "aws_eip" "nat" {
  domain = "vpc"
  tags = {
    Name = "Elastic-ip-for-nat-gateway"
  }
}

resource "aws_nat_gateway" "terraform_nat_gateway" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id

  tags = {
    Name = "terraform-nat-gateway"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.terraform_internet_gateway]
}

resource "aws_route_table" "public_internet_gateway_table" {
    vpc_id = aws_vpc.vpc_terraform.id
    tags = {
        Name = "public_internet_gateway_table"
    }
}
resource "aws_route" "public_igw_route" {
    route_table_id = aws_route_table.public_internet_gateway_table.id
    destination_cidr_block    = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.terraform_internet_gateway.id
}

resource "aws_route_table_association" "public" {
  count          = length(var.vpc_public_subnets)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public_internet_gateway_table.id
}

resource "aws_route_table" "private_internet_gateway_table" {
    vpc_id = aws_vpc.vpc_terraform.id
    tags = {
      Name = "private_internet_gateway_table"
    }
}

resource "aws_route" "private_nat_route" {
    route_table_id         = aws_route_table.private_internet_gateway_table.id
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id         = aws_nat_gateway.terraform_nat_gateway.id
}


resource "aws_route_table_association" "private" {
  count          = length(var.vpc_private_subnets)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private_internet_gateway_table.id
}


