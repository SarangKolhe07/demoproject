locals {
  azs = slice(var.availability_zones, 0, var.az_count)
}

# Create the Paymentology VPC
resource "aws_vpc" "paymentology_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-vpc"
    }
  )
}

resource "aws_flow_log" "vpc_flow" {
  vpc_id               = aws_vpc.paymentology_vpc.id
  traffic_type         = "ALL"
  log_destination_type = "cloud-watch-logs"
  log_destination      = var.vpc_flow_logs_log_group_arn
  iam_role_arn         = var.vpc_flow_logs_iam_role_arn
}

# Create the internet gateway for the VPC
resource "aws_internet_gateway" "paymentology_igw" {
  vpc_id = aws_vpc.paymentology_vpc.id

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-igw"
    }
  )
}

resource "aws_subnet" "public" {
  count                   = length(local.azs)
  vpc_id                  = aws_vpc.paymentology_vpc.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = local.azs[count.index]
  map_public_ip_on_launch = false

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-public-${count.index + 1}"
      Tier = "public"
    }
  )
}

resource "aws_subnet" "private" {
  count             = length(local.azs)
  vpc_id            = aws_vpc.paymentology_vpc.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = local.azs[count.index]

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-private-${count.index + 1}"
      Tier = "private"
    }
  )
}

resource "aws_subnet" "database" {
  count             = var.create_database_subnets ? length(local.azs) : 0
  vpc_id            = aws_vpc.paymentology_vpc.id
  cidr_block        = var.database_subnet_cidrs[count.index]
  availability_zone = local.azs[count.index]

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-database-${count.index + 1}"
      Tier = "database"
    }
  )
}

# Regional NAT Gateway (auto mode) — AWS manages EIPs and expands across all AZs automatically.
# No subnet_id or allocation_id required. Requires AWS provider >= 6.24.0.
resource "aws_nat_gateway" "paymentology_nat" {
  vpc_id            = aws_vpc.paymentology_vpc.id
  connectivity_type = "public"
  availability_mode = "regional"

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-nat-regional"
    }
  )

  depends_on = [aws_internet_gateway.paymentology_igw]
}


# Create the public route table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.paymentology_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.paymentology_igw.id
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-public-rt"
    }
  )
}

resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# Single shared private route table — all private subnets route through the one Regional NAT GW
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.paymentology_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.paymentology_nat.id
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-private-rt"
    }
  )
}

resource "aws_route_table_association" "private" {
  count          = length(aws_subnet.private)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

# Single shared database route table — routes outbound traffic through the Regional NAT GW
resource "aws_route_table" "database" {
  count  = var.create_database_subnets ? 1 : 0
  vpc_id = aws_vpc.paymentology_vpc.id

  # route {
  #   cidr_block     = "0.0.0.0/0"
  #   nat_gateway_id = aws_nat_gateway.paymentology_nat.id
  # }

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-database-rt"
    }
  )
}

resource "aws_route_table_association" "database" {
  count          = var.create_database_subnets ? length(aws_subnet.database) : 0
  subnet_id      = aws_subnet.database[count.index].id
  route_table_id = aws_route_table.database[0].id
}

