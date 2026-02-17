# Fill after creating S3 + DynamoDB via modules/s3-backend
terraform {
  backend "s3" {
    bucket         = "REPLACE_ME"
    key            = "final-project/terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "REPLACE_ME"
    encrypt        = true
  }
}
