terraform {
  required_version = ">=0.12.24"
}

provider "aws" {
  version = "~> 2.62"
  profile = "gabor.nyerges@963491200770"
  region = "eu-central-1"
}

variable "blueprint_id" {
  type = string
}

variable "bundle_type" {
  type = string
}

resource "aws_lightsail_instance" "wordpress" {
  name              = "wordpress"
  availability_zone = "eu-central-1b"
  blueprint_id      = var.blueprint_id
  bundle_id         = var.bundle_type
  tags = {
    project = "tt"
  }
  provisioner "local-exec" {
    command = "aws lightsail put-instance-public-ports --instance-name=wordpress --port-infos fromPort=22,toPort=22,protocol=tcp fromPort=8000,toPort=8000,protocol=tcp --profile=gabor.nyerges@963491200770 --region=eu-central-1"
  }

  user_data = <<EOF
  curl -o lightsail.sh https://raw.githubusercontent.com/gabornyerges/lightsail-compose/master/terraform/lightsail-compose.sh
  chmod +x lightsail.sh
  ./lightsail.sh
EOF
}
