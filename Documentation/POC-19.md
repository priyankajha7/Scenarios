# CI/CD Workflow With Branching Strategy

## 1. Overview

This document describes the CI/CD pipeline implemented using GitHub Actions for Terraform-based infrastructure deployment.

The workflow supports:
- Terraform Plan on Pull Request
- Terraform Apply on Merge to Main
- Manual Production Override
- Artifact-based deployment

---

## 2. Branching Strategy

### Branch Model

| Branch | Purpose |
|--------|----------|
| feature/* | Infrastructure development |
| main | Production-ready infrastructure |

---

## 3. Workflow Triggers

push (main branch only) <br>
workflow_dispatch (manual trigger)

---

## 4. Pull Request Workflow

When a Pull Request is created:

Steps executed:
- Checkout repository
- Configure AWS credentials
- Terraform Init
- Terraform Validate
- Terraform Plan
- Plan stored as artifact
- Plan output added to workflow summary

Apply is NOT executed during PR.

Purpose:
- Validate infrastructure
- Enable review of Terraform plan
- Prevent unintended production changes

---

## 5. Merge to Main Workflow

When PR is merged into main:

Condition: `github.event_name == 'push' && github.ref_name == 'main'`

Steps:
- Download saved Terraform plan artifact
- Initialize Terraform
- Apply execution triggered
- The required infrastructure will be created

---

## 6. Manual Production Override

Workflow includes manual trigger with input:
- ResourceName: Choice
- RegionName: String
- applytoprod: Boolean

Apply runs when:
``
(github.event_name == 'push' && github.ref_name == 'main') ||
(github.event_name == 'workflow_dispatch' && inputs.applytoprod == true)
```

This allows controlled manual deployment.

---

## 7. Environment Protection (Enhancement)

Production environment configured in:

`Repository → Settings → Environments → Production`

Protection Rules:
- Required reviewers enabled
- Optional branch restrictions

Deployment Flow:
PR → Merge → Apply Job → Approval Required → Apply Execution

---

## 8. Artifact-Based Deployment

Terraform plan is stored as an artifact during PR phase.

Apply job:
- Downloads the exact saved plan
- Applies immutable plan

Benefits:
- Prevents drift
- Ensures consistency
- Safe production deployments

---

## 9. Security Controls

- Apply restricted to main branch
- Production approval required
- No direct apply from PR
- AWS credentials stored as GitHub Secrets
- Remote backend for state protection

---

## 10. Summary

This CI/CD implementation provides:
- Enterprise-grade deployment control
- Approval-driven production governance
- Controlled infrastructure evolution
- Secure and automated Terraform deployments