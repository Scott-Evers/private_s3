provider "aws" {
  region  = "us-east-1"
  profile = "privateS3"
}






data "aws_caller_identity" "current" {} 
