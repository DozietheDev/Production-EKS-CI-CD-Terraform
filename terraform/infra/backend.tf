terraform {
  backend "s3" {
    bucket         = "selar-terraform-states"
    key            = "eks/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "selar-terraform-locks"
    encrypt        = true
  }
}
