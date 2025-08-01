terraform {
  backend "s3" {
    bucket = "amazonpro7"
    region = "us-east-1"
    key    = "env/terraform.tfstate"

  }
}

