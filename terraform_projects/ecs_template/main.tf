terraform {
    backend "s3" {
      bucket    = "ecsworkshopbucket"
      key       = "state/terraform.tfstate"
      region    = "us-east-1"
    }
}
