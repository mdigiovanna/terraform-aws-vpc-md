mock_provider "aws" {}

run "multi_az" {

  command = plan

  variables {
    vpc_name = "multi-az"

    vpc_cidr = "10.1.0.0/16"

    availability_zones = [
      "us-east-1a",
      "us-east-1b"
    ]

    public_subnet_cidrs = [
      "10.1.1.0/24",
      "10.1.2.0/24"
    ]

    private_subnet_cidrs = [
      "10.1.101.0/24",
      "10.1.102.0/24"
    ]

    enable_nat_gateway = true

    tags = {
      Environment = "test"
    }
  }

  assert {
    condition = length(aws_subnet.public) == 2

    error_message = "Should create 2 public subnets"
  }

  assert {
    condition = length(aws_subnet.private) == 2

    error_message = "Should create 2 private subnets"
  }

  assert {
    condition = aws_subnet.public[0].availability_zone == "us-east-1a"

    error_message = "Public subnet 1 AZ incorrect"
  }

  assert {
    condition = aws_subnet.public[1].availability_zone == "us-east-1b"

    error_message = "Public subnet 2 AZ incorrect"
  }
}