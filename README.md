# Jenkins on EC2 with Terraform and GitHub Actions Pipeline

<img src="https://img.shields.io/badge/-Jenkins-D24939?&style=for-the-badge&logo=Jenkins&logoColor=white" alt="Jenkins"> <img src="https://img.shields.io/badge/-GitHub_Actions-2088FF?&style=for-the-badge&logo=GitHub-Actions&logoColor=white" alt="GitHub Actions"> <img src="https://img.shields.io/badge/-Terraform-623CE4?&style=for-the-badge&logo=Terraform&logoColor=white" alt="Terraform">

## Overview

This repository contains Terraform scripts to provision a Jenkins server on AWS EC2, and GitHub Actions workflows to manage the infrastructure. The workflows allow you to manually apply and destroy the infrastructure.

## Tools Used

- **Jenkins**: An open-source automation server that helps to automate parts of software development related to building, testing, and deploying.
- **GitHub Actions**: A CI/CD service provided by GitHub that allows you to automate your workflow.
- **Terraform**: An infrastructure as code tool that lets you build, change, and version infrastructure safely and efficiently.

## Setup Instructions

### 1. Prerequisites

- AWS account with appropriate permissions.
- GitHub repository.
- Terraform installed locally (optional but recommended for testing).

### 2. Terraform Configuration

The Terraform script (`main.tf`) provisions the following resources:
- VPC
- Subnet
- Internet Gateway
- Route Table
- Security Group for SSH and Jenkins traffic
- EC2 instance running Jenkins

### 3. GitHub Actions Workflows

#### Apply Infrastructure Workflow

```yaml
name: Apply Jenkins Infrastructure

on:
  workflow_dispatch:

jobs:
  apply:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout repository
        uses: actions/checkout@v2

      - name: Set up Terraform
        uses: hashicorp/setup-terraform@v1
        with:
          terraform_version: 1.0.0

      - name: Terraform Init
        run: terraform init
        working-directory: terraform

      - name: Terraform Apply
        run: terraform apply -auto-approve
        working-directory: terraform
        env:
          AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
          AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}

      - name: Retrieve instance IP
        id: get_ip
        run: echo "::set-output name=instance_ip::$(cat terraform/ip_address.txt)"
```

#### Destroy Infrastructure Workflow

```yaml
name: Destroy Jenkins Infrastructure

on:
  workflow_dispatch:

jobs:
  destroy:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout repository
        uses: actions/checkout@v2

      - name: Set up Terraform
        uses: hashicorp/setup-terraform@v1
        with:
          terraform_version: 1.0.0

      - name: Terraform Init
        run: terraform init
        working-directory: terraform

      - name: Terraform Destroy
        run: terraform destroy -auto-approve
        working-directory: terraform
        env:
          AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
          AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
```

### 4. Setting Up GitHub Secrets

Ensure you store your AWS credentials in GitHub Secrets:
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`

### 5. Running the Workflows

1. Go to the Actions tab in your GitHub repository.
2. Select the "Apply Jenkins Infrastructure" workflow and click "Run workflow".
3. To destroy the infrastructure, select the "Destroy Jenkins Infrastructure" workflow and click "Run workflow".

### 6. Terraform Directory Structure

```
terraform/
  ├── main.tf
  ├── variables.tf
  ├── outputs.tf
```

### 7. Outputs

The Apply workflow retrieves the public IP of the Jenkins server and outputs it. You can use this IP to access your Jenkins server.

## Conclusion

This setup automates the deployment and management of a Jenkins server on AWS using Terraform and GitHub Actions, providing a seamless CI/CD pipeline with minimal manual intervention.
