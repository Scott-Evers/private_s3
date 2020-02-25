provider "aws" {
  region  = "us-east-1"
  profile = "privateS3"
}
provider "aws" {
  alias     = "root"
  region    = "us-east-1"
  profile   = "evers"
}






data "aws_organizations_organization" "myorg" {
    provider = aws.root
} 
