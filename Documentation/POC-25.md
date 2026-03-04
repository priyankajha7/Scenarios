# Infrastructure as Code (IaC) – EC2 & S3 using Terraform

## 1. Overview

This document describes the Infrastructure as Code (IaC) implementation for provisioning AWS resources using Terraform.

Provisioned Resources:
- Amazon S3 Bucket
- Amazon EC2 Instance
- Security Group
- Remote Terraform State Backend (S3)

The infrastructure is:
- Declarative
- Version controlled
- Region-specific
- Environment-driven
- CI/CD integrated (enhancement)

---

## 2. Project Structure
```
terraform
│
├── S3
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── backend.tf
│
├── EC2_Instance
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── backend.tf
│
My_AWS_Account
└── us-east-1
    ├── S3
    │   ├── terraform.tfvars
    │   └── backend.tfvars
    └── EC2_Instance
        ├── terraform.tfvars
        └── backend.tfvars
```

---

## 3. S3 Bucket Provisioning

### Purpose
Provision an Amazon S3 bucket using Terraform with region-specific configuration.

### Features
- Parameterized bucket name
- Region configurable
- Tagging enabled
- Remote backend configured
- Environment-based tfvars

### Execution

```
terraform fmt
terraform init -backend-config="../../My_AWS_Account/us-east-1/S3/backend.tfvars"
terraform validate
terraform plan -lock-timeout=30s -var-file="../../My_AWS_Account/us-east-1/S3/terraform.tfvars" -out="state.plan"
terraform apply "state.plan"
```

---

## 4. EC2 Instance Provisioning

### Components Created
- EC2 Instance
- Security Group
- SSH Key Pair (optional)
- Region-based AMI

### Features
- Instance type configurable
- AMI configurable per region
- Security group with ingress rules
- SSH access configuration
- Tagging enabled

---

## 5. Remote State Management

Terraform backend uses S3 for storing state.

### Benefits
- Centralized state storage
- State locking
- Collaboration-safe
- Environment isolation

Backend configuration loaded using:<br>
`-backend-config="../../My_AWS_Account/<region>/<resource>/backend.tfvars"`

---

## 6. Security Best Practices

- No hardcoded credentials
- AWS credentials injected via GitHub Secrets
- Remote backend secured
- Controlled infrastructure changes via Pull Requests
- Separate configuration per region

---

## 7. Summary

This Terraform implementation ensures:
- Modular infrastructure
- Clean separation of resources
- Region-based deployment
- Secure remote state
- CI/CD compatibility