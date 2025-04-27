terraform {
  backend "s3" {
    bucket = "lightfeather002"   
    key    = "terraform/state.tfstate"  
    region = "us-west-2"        
    encrypt = true              
  }
}