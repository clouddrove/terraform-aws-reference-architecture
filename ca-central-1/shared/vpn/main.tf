provider "aws" {
  region = "ca-central-1"
}

module "http-https" {
  source  = "clouddrove/security-group/aws"
  version = "0.14.0"

  name        = "http-https"
  environment = "test"
  label_order = ["environment", "name"]

  vpc_id        = module.vpc.vpc_id
  allowed_ip    = ["0.0.0.0/0"]
  allowed_ports = [80, 443]
}

module "ssh" {
  source  = "clouddrove/security-group/aws"
  version = "0.14.0"

  name        = "ssh"
  environment = "test"
  label_order = ["environment", "name"]

  vpc_id        = module.vpc.vpc_id
  allowed_ip    = [module.vpc.vpc_cidr_block, "0.0.0.0/0"]
  allowed_ports = [22]
}


    module "ec2" {
      source                      = "clouddrove/ec2/aws"
      version                     = "0.14.0"
      repository                  = "https://registry.terraform.io/modules/clouddrove/ec2/aws/0.14.0"
      environment                 = var.environment
      label_order                 = var.label_order
      instance_count              = 1
      ami                         = "ami-08d658f84a6d84a80"
      instance_type               = "t2.nano"
      monitoring                  = false
      tenancy                     = "default"
      vpc_security_group_ids_list = [module.ssh.security_group_ids, module.http-https.security_group_ids]
      subnet_ids                  = tolist(module.public_subnets.public_subnet_id)
      assign_eip_address          = true
      associate_public_ip_address = true
      instance_profile_enabled    = true
      iam_instance_profile        = module.iam-role.name
      disk_size                   = 8
      ebs_optimized               = false
      ebs_volume_enabled          = true
      ebs_volume_type             = "gp2"
      ebs_volume_size             = 30
      encrypted                   = true
      kms_key_id                  = module.kms_key.key_arn
      instance_tags               = { "snapshot" = true }
      dns_zone_id                 = "Z1XJD7SSBKXLC1"
      hostname                    = "ec2"
    }