mock_provider "aws" {}

run "tagging" {

  command = plan

  variables {
    vpc_name = "tagged-vpc"

    vpc_cidr = "10.4.0.0/16"

    availability_zones = ["us-east-1a"]

    public_subnet_cidrs = ["10.4.1.0/24"]

    private_subnet_cidrs = ["10.4.101.0/24"]

    tags = {
      Environment = "dev"
      Owner = "Mikey"
    }
  }

  assert {
    condition = aws_vpc.this.tags["Owner"] == "Mikey"

    error_message = "Owner tag missing"
  }

  assert {
    condition = aws_vpc.this.tags["Environment"] == "dev"

    error_message = "Environment tag missing"
  }
}