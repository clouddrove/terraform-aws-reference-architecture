provider "aws" {
  region = "eu-west-1"
}


module "s3_bucket" {

  source  = "clouddrove/s3/aws"
  version = "0.14.0"

  name        = "vpc-logs-s3"
  environment = "prod"
  label_order = ["environment", "name"]

  acl            = "private"
  bucket_enabled = true
  versioning     = true
}

module "vpc" {
  source  = "clouddrove/vpc/aws"
  version = "0.14.0"

  vpc_enabled     = true
  enable_flow_log = true

  name        = "vpc"
  environment = "prod"
  label_order = ["environment", "name"]

  cidr_block    = "10.0.0.0/16"
  s3_bucket_arn = module.s3_bucket.arn
}

module "subnets" {
  source  = "clouddrove/terraform-aws-subnet/aws"
  version = "0.14.0"

  nat_gateway_enabled = true

  name        = "subnet"
  environment = "test"
  label_order = ["environment", "name"]

  cidr_block         = "10.0.0.0/16"
  availability_zones = ["eu-west-1a"]
  vpc_id             = module.vpc.id
  type               = "public-private"
  igw_id             = module.vpc.igw_id
  ipv6_cidr_block    = module.vpc.ipv6_cidr_block
}
