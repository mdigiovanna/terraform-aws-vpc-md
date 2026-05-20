mock_provider "aws" {}

run "minimal_vpc" {

  command = plan

  variables {
    vpc_name = "test-vpc"

    vpc_cidr = "10.0.0.0/16"

    availability_zones = ["us-east-1a"]

    public_subnet_cidrs = ["10.0.1.0/24"]

    private_subnet_cidrs = ["10.0.101.0/24"]

    enable_nat_gateway = false

    enable_dns_hostnames = true
    enable_dns_support   = true

    tags = {
      Environment = "test"
    }
  }

  assert {
      condition = aws_vpc.this.cidr_block == "10.0.0.0/16"
      
      error_message = "VPC CIDR block incorrect"
  }

  assert {
      condition = aws_vpc.this.enable_dns_hostnames == true

      error_message = "DNS hostnames should be enabled"
  }

  assert {
      condition = aws_vpc.this.enable_dns_support == true

      error_message = "DNS support should be enabled"
  }

  assert {
      condition = length(aws_subnet.public) == 1

      error_message = "Should create 1 public subnet"
  }

  assert {
      condition = length(aws_subnet.private) == 1

      error_message = "Should create 1 private subnet"
  }
}