terraform {
  backend "s3" {
    bucket = "demo-pro9"
    region = "us-east-1"
    key    = "env/terraform.tfstate"

  }
}

