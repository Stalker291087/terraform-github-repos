terraform {
  backend "local" {
    path = "./state-file/terraform.tfstate"
  }
}