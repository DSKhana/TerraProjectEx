// VPC 정의 영역 ( DNS Hostnames, DNS support 기능 활성화 )
resource "aws_vpc" "my_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  instance_tenancy     = "default"
  tags = {
    Name = "my_vpc"
  }
}

// public subnets 정의 영역
resource "aws_subnet" "my_vpc_public_subnet1" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = var.public-1_cidr
  map_public_ip_on_launch = true
  availability_zone       = "ap-northeast-2a"
  tags = {
    Name = "public-1"
  }
}

resource "aws_subnet" "my_vpc_public_subnet2" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = var.public-2_cidr
  map_public_ip_on_launch = true
  availability_zone       = "ap-northeast-2c"
  tags = {
    Name = "public-2"
  }
}

// private subnets 정의 영역
resource "aws_subnet" "my_vpc_private_subnet1" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = var.private-1_cidr
  availability_zone = "ap-northeast-2a"
  tags = {
    Name = "private-1"
  }
}

resource "aws_subnet" "my_vpc_private_subnet2" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = var.private-2_cidr
  availability_zone = "ap-northeast-2c"
  tags = {
    Name = "private-2"
  }
}

resource "aws_subnet" "my_vpc_private_subnet3" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = var.private-3_cidr
  availability_zone = "ap-northeast-2c"
  tags = {
    Name = "private-2"
  }
}

resource "aws_subnet" "my_vpc_private_subnet4" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = var.private-4_cidr
  availability_zone = "ap-northeast-2c"
  tags = {
    Name = "private-2"
  }
}

// 인터넷 게이트웨이 (IGW) 정의 영역
resource "aws_internet_gateway" "my_vpc_igw" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "my_vpc_internet-gateway"
  }
}

// VPC 생성 시 자동생성되는 Default Routing Table TAG 설정
resource "aws_default_route_table" "my_vpc_public_routing_table" {
  default_route_table_id = aws_vpc.my_vpc.default_route_table_id
  tags = {
    Name = "my_vpc_public_routing_table"
  }
}

// Routing Table 정의 영역 ( route to Internet )
resource "aws_route" "my_vpc_internet" {
  route_table_id         = aws_vpc.my_vpc.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.my_vpc_igw.id
}

// NAT Gateway and EIP 정의 영역
resource "aws_eip" "my_vpc_eip" {
  tags = {
    Name = "NAT_GW_EIP"
  }
}

resource "aws_nat_gateway" "my_vpc_nat_gw" {
  allocation_id = aws_eip.my_vpc_eip.id
  subnet_id     = aws_subnet.my_vpc_public_subnet1.id
}

// Routing Table 정의 영역 ( Private Subnet Route )
// Private Routing Table 생성
resource "aws_route_table" "my_vpc_private_routing_table" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "my_vpc_private_routing_table"
  }
}

// Private Routing Table 정의
resource "aws_route" "my_vpc_private_route" {
  route_table_id         = aws_route_table.my_vpc_private_routing_table.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.my_vpc_nat_gw.id
}

// Public Subnet -> Default Routing Table 연결
resource "aws_route_table_association" "my_vpc_public_subnet1_association" {
  subnet_id      = aws_subnet.my_vpc_public_subnet1.id
  route_table_id = aws_vpc.my_vpc.main_route_table_id
}

resource "aws_route_table_association" "my_vpc_public_subnet2_association" {
  subnet_id      = aws_subnet.my_vpc_public_subnet2.id
  route_table_id = aws_vpc.my_vpc.main_route_table_id
}

// Private Subnet -> Private Routing Table 연결
resource "aws_route_table_association" "my_vpc_private_subnet1_association" {
  subnet_id      = aws_subnet.my_vpc_private_subnet1.id
  route_table_id = aws_route_table.my_vpc_private_routing_table.id
}

resource "aws_route_table_association" "my_vpc_private_subnet2_association" {
  subnet_id      = aws_subnet.my_vpc_private_subnet2.id
  route_table_id = aws_route_table.my_vpc_private_routing_table.id
}

resource "aws_route_table_association" "my_vpc_private_subnet3_association" {
  subnet_id      = aws_subnet.my_vpc_private_subnet3.id
  route_table_id = aws_route_table.my_vpc_private_routing_table.id
}

resource "aws_route_table_association" "my_vpc_private_subnet4_association" {
  subnet_id      = aws_subnet.my_vpc_private_subnet4.id
  route_table_id = aws_route_table.my_vpc_private_routing_table.id
}

// Key Pair Data Source 영역
data "aws_key_pair" "EC2-Key" {
  key_name = "EC2-key"
}

// SSH 원격접속을 위한 Security-Group Resource 정의
resource "aws_security_group" "BastionHost_sg" {
  name        = "BastionHost_Connection"
  description = "Allow SSH Traffic"
  vpc_id      = aws_vpc.my_vpc.id
  ingress {
    from_port   = var.ssh_port
    to_port     = var.ssh_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

// EC2 Instance Resource 영역
resource "aws_instance" "BastionHost" {
  ami                         = "ami-0ea4d4b8dc1e46212"
  instance_type               = "t2.micro"
  key_name                    = data.aws_key_pair.EC2-Key.key_name
  availability_zone           = aws_subnet.my_vpc_public_subnet2.availability_zone
  subnet_id                   = aws_subnet.my_vpc_public_subnet2.id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.BastionHost_sg.id]

  # 가용영역 Public Subnet 1과 동일한 영역을 사용하도록 정의
  # BastionHost 생성 Subnet 지정 ( Public Subnet 1 )
  # Public IP 부여 ( True )

  tags = {
    Name = "BastionHost_Instance"
  }
}

// BastionHost에 고정적인 Public IP를 부여하기 위해 EIP 설정을 함께 진행
resource "aws_eip" "BastionHost_eip" {
  instance = aws_instance.BastionHost.id
  tags = {
    Name = "BastionHost_EIP"
  }
}