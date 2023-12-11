packer {
  required_plugins {
    amazon = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "windows-server" {
  profile           = "e360-AdministratorAccess-950694031822"
  region            = "us-west-2"
  instance_type     = "t2.large"
  source_ami_filter {
    filters = {
      name                = "Windows_Server-2022-English-Full-Base-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    owners      = ["amazon"]
    most_recent = true
  }
  communicator = "winrm"
  winrm_username = "Administrator"
  ami_name = "windows-server-2022-{{timestamp}}"
}

build {
  sources = [
    "source.amazon-ebs.windows-server"
  ]

  // Add your provisioners and other configurations here
}