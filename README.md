# Terraform AWS Infrastructure

## Overview

This project demonstrates how to provision and manage AWS infrastructure using **Terraform**, **GitHub**, **AWS EC2**, and **Amazon S3 Remote State**.

The project was built as a hands-on Infrastructure as Code (IaC) exercise covering Terraform configuration, AWS networking, EC2 provisioning, Terraform state management, GitHub integration, IAM permissions, and remote state management.

---

## Architecture

# Terraform AWS Infrastructure

## Overview

This project demonstrates how to provision and manage AWS infrastructure using **Terraform**, **GitHub**, **AWS EC2**, and **Amazon S3 Remote State**.

The project was built as a hands-on Infrastructure as Code (IaC) exercise covering Terraform configuration, AWS networking, EC2 provisioning, Terraform state management, GitHub integration, IAM permissions, and remote state management.

---

## Architecture
`
                         GitHub
                           |
                           | Terraform Code
                           v
                Terraform Workstation EC2
                           |
                           | Terraform
                           |
              +------------+-------------+
              |                          |
              v                          v
       AWS Infrastructure           S3 Backend
              |                          |
              |                          |
       +------+-------+                  |
       |      |       |                  |
      VPC   Security  EC2                |
       |     Group    |                  |
       |              |                  |
       |      terraform-jenkins-server   |
       |                                 |
       +---------------------------------+
                                         |
                              terraform/terraform.tfstate


1. AWS Resources Created

The Terraform configuration creates the following AWS resources:

VPC
Public Subnet
Internet Gateway
Route Table
Route Table Association
Security Group
EC2 Instance

AWS Region:

ap-south-1 (Mumbai)

2. Project Structure
Terraform-AWS-Infrastructure/
│
├── provider.tf
├── variables.tf
├── vpc.tf
├── subnet.tf
├── internet-gateway.tf
├── route-table.tf
├── security-group.tf
├── ec2.tf
├── outputs.tf
├── README.md
├── .gitignore
└── .terraform.lock.hcl

Terraform automatically loads all .tf files in the same directory.

3. Terraform Workstation
A separate Amazon Linux EC2 instance was created as the Terraform workstation.

The workstation is used to:

Install Git
Install Terraform
Clone the GitHub repository
Run Terraform commands
Manage AWS infrastructure

4. Install Git
Install Git:
sudo dnf install git -y
Verify:
git --version

5. Install Terraform

Install the required repository tools:

sudo dnf install -y dnf-plugins-core

Add the HashiCorp repository:

sudo dnf config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo

Install Terraform:

sudo dnf -y install terraform

Verify:

terraform --version

6. Clone the Repository

Clone the repository using SSH:

git clone git@github.com:kathavishnuvardhanreddy-prog/Terraform-AWS-Infrastructure.git

Move into the project:

cd Terraform-AWS-Infrastructure

Check the files:

ls

7. GitHub SSH Authentication

SSH authentication was configured between the Terraform workstation EC2 and GitHub.

This allows Git operations without repeatedly entering a GitHub username and Personal Access Token.

Generate SSH Key
ssh-keygen -t ed25519 -C "terraform-ec2-github"

The public key is:

~/.ssh/id_ed25519.pub

The private key is:

~/.ssh/id_ed25519

The private key must never be shared or committed to GitHub.

Test GitHub SSH Connection
ssh -T git@github.com

Expected response:

Hi <github-username>! You've successfully authenticated, but GitHub does not provide shell access.
Configure Git Remote

Check the current remote:

git remote -v

Change the remote to SSH:

git remote set-url origin git@github.com:kathavishnuvardhanreddy-prog/Terraform-AWS-Infrastructure.git

Verify:

git remote -v

Expected format:

origin  git@github.com:kathavishnuvardhanreddy-prog/Terraform-AWS-Infrastructure.git (fetch)
origin  git@github.com:kathavishnuvardhanreddy-prog/Terraform-AWS-Infrastructure.git (push)

8. Terraform Provider

The AWS provider is configured in provider.tf.

The project uses:

Provider: AWS
Region: ap-south-1

The AWS region is controlled using a Terraform variable.

9. VPC

A VPC was created with:

CIDR: 10.0.0.0/16

DNS support and DNS hostnames are enabled.

10. Public Subnet

A public subnet was created:

CIDR: 10.0.1.0/24
Availability Zone: ap-south-1a

Public IP assignment is enabled.

11. Internet Gateway

An Internet Gateway was created and attached to the VPC.

It provides internet connectivity for resources in the public subnet when the appropriate route is configured.

12. Route Table

A public route table was created.

Default route:

0.0.0.0/0 → Internet Gateway

The public subnet is associated with this route table.

13. Security Group

A security group was created for the Terraform-managed EC2.

The learning configuration allows:

SSH          → 22
Jenkins      → 8080
Application  → 8081

The current learning configuration allows inbound traffic from:

0.0.0.0/0

For production environments, access should be restricted to trusted IP ranges or appropriate network security controls.

14. Terraform Variables

Terraform variables were used to avoid hardcoding configuration values.

Variables include:

aws_region
vpc_cidr
public_subnet_cidr
availability_zone
ssh_port
jenkins_port
application_port

This makes the configuration easier to reuse and modify.

15. EC2 Provisioning

Terraform uses an AWS AMI data source to find the latest Amazon Linux 2023 x86_64 AMI.

The Terraform-managed EC2 uses:

Operating System: Amazon Linux 2023
Instance Type: t3.micro
Subnet: Public Subnet
Public IP: Enabled

Instance name:

terraform-jenkins-server

16. Terraform Outputs

The following outputs are configured:

ec2_public_ip
ec2_instance_id
ec2_public_dns

View outputs:

terraform output

17. Terraform Initialization

Initialize the Terraform project:

terraform init

This downloads the required providers and initializes the Terraform working directory.

18. Terraform Validation

Validate the Terraform configuration:

terraform validate

Expected result:

Success! The configuration is valid.

19. Terraform Plan

Create a Terraform execution plan:

terraform plan

Terraform compares the configuration, state, and actual AWS infrastructure.

Conceptually:

Terraform Configuration
          +
Terraform State
          +
Actual AWS Infrastructure
          |
          v
   Terraform Plan

Common plan symbols:

+     Create
~     Modify
-     Destroy
-/+   Replace
20. Terraform Apply

Apply the infrastructure:

terraform apply

Terraform displays the proposed changes.

Enter:

yes

to approve the changes.

21. Terraform State

Terraform state maintains the relationship between Terraform resources and real AWS resources.

Example:

aws_instance.jenkins
        |
        v
terraform.tfstate
        |
        v
Real AWS EC2 Instance

List Terraform-managed resources:

terraform state list

The state file should not be committed to GitHub.

22. Git Ignore

The project contains a .gitignore file to prevent Terraform state and local Terraform files from being committed.

Important ignored files:

.terraform/
*.tfstate
*.tfstate.*
*.tfvars
*.tfvars.json

The Terraform provider lock file:

.terraform.lock.hcl

should be committed to GitHub.

23. S3 Remote Backend

Initially, Terraform state was stored locally.

The project was then migrated to an Amazon S3 remote backend.

Architecture:

Terraform Workstation EC2
          |
          v
     S3 Bucket
          |
          v
terraform/terraform.tfstate

The S3 bucket was configured with:

Versioning enabled
Block Public Access enabled
Encryption enabled

Terraform backend configuration:

backend "s3" {
  bucket       = "<YOUR-TERRAFORM-STATE-BUCKET>"
  key          = "terraform/terraform.tfstate"
  region       = "ap-south-1"
  use_lockfile = true
}

Replace <YOUR-TERRAFORM-STATE-BUCKET> with the actual S3 bucket name when setting up the project.

24. IAM Role for Terraform

The Terraform workstation EC2 uses an IAM role:

TerraformEC2Role

The role allows Terraform to interact with AWS.

Additional S3 permissions were configured for the Terraform remote state bucket.

The permissions allow Terraform to:

List the Terraform state bucket
Read the Terraform state
Write/update the Terraform state
Delete/update state objects when required

The permissions are scoped to the Terraform state bucket rather than granting unrestricted S3 access.

25. Verify S3 Remote State

Check the remote state:

aws s3 ls s3://<YOUR-TERRAFORM-STATE-BUCKET>/terraform/

Expected state location:

terraform/terraform.tfstate

Check Terraform-managed resources:

terraform state list

Verify that Terraform and AWS are synchronized:

terraform plan

When everything is synchronized, Terraform should report:

No changes. Your infrastructure matches the configuration.

26. Terraform Change Management

Terraform was used to modify an existing EC2 instance.

The instance type was changed:

t3.micro
    ↓
t3.small

Workflow:

Modify Terraform Code
        ↓
terraform plan
        ↓
Review Changes
        ↓
terraform apply
        ↓
AWS Infrastructure Updated

The instance was then changed back:

t3.small
    ↓
t3.micro

This demonstrated how Terraform detects and applies infrastructure changes.

27. Terraform Workflow

The complete workflow used in this project:

Write Terraform Code
        ↓
git add
        ↓
git commit
        ↓
git push
        ↓
terraform init
        ↓
terraform validate
        ↓
terraform plan
        ↓
Review Changes
        ↓
terraform apply
        ↓
AWS Infrastructure
        ↓
S3 Remote State Updated

28. Important Terraform Commands

Initialize: terraform init

Validate: terraform validate

Plan: terraform plan

Apply: terraform apply

Show outputs: terraform output

List Terraform resources:

terraform state list

Check Git status:

git status

Add files:

git add .

Commit:

git commit -m "Update Terraform configuration"

Push:

git push

29. Security Notes

The following should never be committed to GitHub:

terraform.tfstate
terraform.tfstate.*
.terraform/
*.tfvars
AWS access keys
AWS secret keys
GitHub Personal Access Tokens
SSH private keys
Passwords
Other secrets

The SSH private key:

~/.ssh/id_ed25519

must remain private.

Only the public key:

~/.ssh/id_ed25519.pub

is added to GitHub.

30. Current Project Status

Completed:

 Created Terraform workstation EC2
 Installed Git
 Installed Terraform
 Connected GitHub repository
 Configured GitHub SSH authentication
 Configured AWS provider
 Created Terraform variables
 Created VPC
 Created public subnet
 Created Internet Gateway
 Created route table
 Created route table association
 Created security group
 Created EC2 using Terraform
 Configured Terraform outputs
 Ran terraform init
 Ran terraform validate
 Ran terraform plan
 Ran terraform apply
 Learned Terraform state
 Created .gitignore
 Added .terraform.lock.hcl
 Configured S3 remote state
 Configured IAM permissions for S3 backend
 Migrated local state to S3
 Verified remote state
 Practiced modifying existing infrastructure
 Practiced reverting infrastructure changes

31. Future Improvements

Planned next steps:

Terraform Modules
Improve Security Group rules
IAM least-privilege improvements
Configure EC2 key pair and secure access
Jenkins integration
GitHub → Jenkins → Terraform automation
Terraform plan/apply through Jenkins
Automated infrastructure deployment
CI/CD integration

32. Final Architecture
                         Developer
                             |
                             v
                          GitHub
                             |
                             | Terraform Code
                             v
                  Terraform Workstation EC2
                             |
                             | Terraform
                             |
              +--------------+---------------+
              |                              |
              v                              v
       AWS Infrastructure               S3 Backend
              |                              |
       +------+-------+                      |
       |      |       |                      |
      VPC   Network   EC2                    |
       |     Config   |                      |
       |              |                      |
       |      terraform-jenkins-server       |
       |                                     |
       +-------------------------------------+
                                             |
                                  terraform.tfstate
                              
