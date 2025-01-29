terraform {
    backend "s3" {
        bucket = "terraform07"
        region = "eu-north-1"
        key = "statefile/terraform.tfstate"
        dynamodb_table = "terraform_lock"
    } 
}