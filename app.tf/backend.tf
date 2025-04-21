terraform {
  backend "s3" {
    bucket         = "cuongnvecl"
    key            = "cuongnvecl-github-ci/infra/provisionecl1.tfstate"
    region         = "ap-southeast-2"
    
  }
}