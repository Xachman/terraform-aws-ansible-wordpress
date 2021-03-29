provider "aws" {
    access_key = local.aws_access_key
    secret_key = local.aws_secret_key
    region = local.region
}
