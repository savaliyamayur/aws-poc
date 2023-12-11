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

  vpc_id     = "vpc-0fb3b9a980ab34f36"       // Replace with your VPC ID
  subnet_id  = "subnet-02787bca2c3449c2b"    // Replace with your Subnet ID
  // If needed, specify security group and key pair
  // security_group_id = "your-security-group-id"
  // ssh_keypair_name  = "windows"
}

build {
  sources = [
    "source.amazon-ebs.windows-server"
  ]

  // Add your provisioners and other configurations here
}
