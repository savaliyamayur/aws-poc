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
  winrm_password = "some0thingG?me5" // Adjust as per your security practices
  winrm_timeout = "10m"

  // Specify the user data file to execute on instance creation
  user_data_file = "scripts/initialize-winrm.ps1"
  ami_name = "windows-server-2022-{{timestamp}}"

  vpc_id     = "vpc-0fb3b9a980ab34f36"       // Replace with your VPC ID
  subnet_id  = "subnet-02787bca2c3449c2b"    // Replace with your Subnet ID
  // If needed, specify security group and key pair
  security_group_id = "sg-00761bc8c49c22b50"
  // ssh_keypair_name  = "windows"
}

build {
  sources = [
    "source.amazon-ebs.windows-server"
  ]

  provisioner "powershell" {
    inline = [
      "Set-ExecutionPolicy Bypass -Scope Process -Force;",
      "[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072;",
      "iwr https://chocolatey.org/install.ps1 -UseBasicParsing | iex"
    ]
  }

  provisioner "powershell" {
    inline = [
      "choco install python3 -y",
      "choco install openjdk -y",
      // For MS Office 365, ensure you have the right package and license
      // "choco install microsoft-office365-business -y",  // Check for correct package name
      "choco install microsoft-teams -y",
      "choco install pycharm-community -y"
    ]
  }

  // Add any additional provisioners here
}
