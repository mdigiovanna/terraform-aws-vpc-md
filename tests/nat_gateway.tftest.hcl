mock_provider "aws" {}

run "single_nat_gateway" {

  command = plan

  variables {
    vpc_name = "single-nat"

    vpc_cidr = "10.2.0.0/16"

    availability_zones = [
      "us-east-1a",
      "us-east-1b"
    ]

    public_subnet_cidrs = [
      "10.2.1.0/24",
      "10.2.2.0/24"
    ]

    private_subnet_cidrs = [
      "10.2.101.0/24",
      "10.2.102.0/24"
    ]

    enable_nat_gateway = true
    single_nat_gateway = true
  }

  assert {
    condition = length(aws_nat_gateway.this) == 1

    error_message = "Should create exactly 1 NAT Gateway"
  }
}

run "nat_disabled" {

  command = plan

  variables {
    vpc_name = "nat-disabled"

    vpc_cidr = "10.3.0.0/16"

    availability_zones = ["us-east-1a"]

    public_subnet_cidrs = ["10.3.1.0/24"]

    private_subnet_cidrs = ["10.3.101.0/24"]

    enable_nat_gateway = false
  }

  assert {
    condition = length(aws_nat_gateway.this) == 0

    error_message = "No NAT gateways should exist"
  }
}