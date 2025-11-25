# Blue-Green Deployment on AWS with EC2, ALB, Docker, Terraform & GitHub Actions

This project implements an automated **Blue-Green deployment pipeline** using:

- Two EC2 instances (Blue & Green)
- Application Load Balancer (ALB)
- Dockerized Node.js web application
- GitHub Container Registry (GHCR)
- GitHub Actions CI/CD workflows
- Full Terraform IaC stack (VPC, Subnets, ALB, TGs, EC2, SGs, IAM)
- Zero-downtime deployments with rollback safety checks

---

# 1. High-Level Overview

### 🎯 What This Project Demonstrates
- Production-style **Blue-Green deployments**
- Clean CI/CD pipeline with **GitHub Actions**
- **Terraform** provisioning for AWS infrastructure
- **Docker image builds** with tagged releases
- **Full health-checked deployments**
- **Automatic rollback** if unhealthy

### 💡 Why Blue-Green?
Blue-Green deployments maintain two identical environments:

- **Blue** = currently live environment  
- **Green** = staging environment for next deployment  

Deploy to the inactive environment → verify → flip traffic → instant rollback available.

---

# 2. Architecture Diagram

This diagram reflects the actual system you deployed:

```mermaid
flowchart LR
  user[User / Browser] --> alb[Application Load Balancer<br/>HTTP :80]

  subgraph TGs[ALB Target Groups]
    tgBlue[TG - Blue]
    tgGreen[TG - Green]
  end

  alb --> tgBlue
  alb --> tgGreen

  tgBlue --> ec2Blue[EC2 - Blue<br/>Dockerized App]
  tgGreen --> ec2Green[EC2 - Green<br/>Dockerized App]

  subgraph CI_CD[GitHub Actions CI/CD]
    dev[Developer Push to main] --> ci[CI Workflow<br/>Build + Push to GHCR]
    ci --> ghcr[GitHub Container Registry]
    ci --> cd[CD Workflow<br/>Blue-Green Deploy]
    cd -->|SSH + docker pull/run| ec2Blue
    cd -->|SSH + docker pull/run| ec2Green
  end

.
├── app/                     # Node.js application
│   ├── Dockerfile
│   ├── package.json
│   └── server.js            # Includes / and /healthz endpoints
│
├── infra/                   # Terraform IaC
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── networking/
│   ├── alb/
│   └── compute/
│
├── .github/
│   └── workflows/
│       ├── ci.yml           # Build + push to GHCR
│       └── cd.yml           # Blue-Green rollout + rollback
│
└── docs/
    ├── architecture.md
    └── screenshots/

