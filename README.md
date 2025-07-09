AWS Infrastructure Provisioning with Terraform

This project provisions a complete AWS infrastructure using Terraform, and deploys a demo application on an Ubuntu EC2 instance. It demonstrates Infrastructure as Code (IaC) best practices, secure network design, and automated provisioning.

-> Components Provisioned

- VPC – Custom virtual private cloud
- Subnets – Public subnet for EC2 hosting
- Internet Gateway – For internet access
- Route Table – Routing for public subnet
- Security Group – Inbound rules for HTTP (port 80), SSH (port 22)
- EC2 Instance – Ubuntu-based, user_data bootstraps a web app
- Key Pair – For SSH access
- Output – Displays public IP of instance

 -> Tech Stack

- Terraform (Infrastructure as Code)
- AWS EC2, VPC, SG, Subnet
- Ubuntu (for demo app hosting)
- User Data for automated provisioning


-> Folder Structure

terraform-project/
├── main.tf # All resource definitions
├── variables.tf # Variable declarations
├── terraform.tfvars # Variable values (environment-specific)
├── providers.tf # AWS provider config
├── key/ # SSH key pair (optional)
└── README.md # Project documentation


-> App demonstartion :
	This is developed to demonstrate a simple app to show the welcome page in ec2 Instance.

On EC2 launch, a simple app is bootstrapped via `user_data`:

bash
#!/bin/bash
sudo apt update -y
sudo apt install -y apache2
echo "Hello from Terraform on Ubuntu" > /var/www/html/index.html

-> Security Considerations
	- Security group allows only HTTP (80) and SSH (22) access.
	- SSH key pair used for secure login.
	- Terraform state should be stored securely (e.g., remote backend in S3 with state locking via DynamoDB).

-> Troubleshooting:

	- I have used created security group with wrong protocols, So while trying to open the EC2 with public-IP faced issues
	- User data updated is not working, later fixed those issues and understand where it had gone wrong and fixed it.
	- Used terraform validate command, To check the HCL language configured

-> Learnings & Highlights

	- Hands-on understanding of Terraform AWS provider
	- Designing secure and scalable infrastructure
	- Bootstrapping EC2 with user_data
	- Managing variables, outputs, and state files


