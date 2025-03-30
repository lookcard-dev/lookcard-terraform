include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../"
}

locals {
  # Load the image tags from the separate JSON file
  image_tags = jsondecode(file("${get_parent_terragrunt_dir()}/image_tags/develop.json"))
}

inputs = {
  aws_provider = {
    application = {
      region = "ap-southeast-1",
      account_id = "559050227374",
      profile = "lookcard-development"
    },
    dns = {
      region = "us-east-1",
      account_id = "836984897828",
      profile = "lookcard-dns"
    }
  },
  domain = {
    general = {
      name = "develop.not-lookcard.com",
      zone_id = "Z09420233KRQ3SUG3Q33B"
    },
    admin = {
      name = "develop.not-lookcard.com",
      zone_id = "Z09420233KRQ3SUG3Q33B"
    }
  },
  network = {
    cidr = {
      vpc = "10.0.0.0/16",
      subnets = {
        public = [
          "10.0.24.0/23",
          "10.0.26.0/23", 
          "10.0.28.0/23"
        ],
        private = [
          "10.0.0.0/21",
          "10.0.8.0/21",
          "10.0.16.0/21"
        ],
        database = [
          "10.0.36.0/24",
          "10.0.37.0/24",
          "10.0.38.0/24"
        ],
        isolated = [
          "10.0.30.0/23",
          "10.0.32.0/23",
          "10.0.34.0/23"
        ]
      }
    },
    nat = {
      provider = "instance",
      count = 3
    }
  },
  runtime_environment = "develop",
  
  # Load image tags from the external file
  image_tag = local.image_tags
}
