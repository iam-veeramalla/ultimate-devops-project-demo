# OpenTelemetry Microservices Demo 🚀

A full-stack **microservices demo application** designed to showcase modern **DevOps practices** including **containerization**, **CI/CD**, **observability**, and **cloud-native deployment** using **Kubernetes (EKS)** and **OpenTelemetry**.

---

## 📦 Overview

This demo simulates a production-grade ecommerce platform with over 20 microservices written in various languages including Go, Java, Python, and Node.js. It integrates:

- 🚀 Continuous Integration with GitHub Actions
- 🐳 Docker-based microservices (multi-language support)
- ☸️ Kubernetes orchestration with AWS EKS
- 🔭 Observability via OpenTelemetry (tracing + metrics)
- ⚙️ Infrastructure as Code (IaC) with Terraform
- 🌐 Ingress Controller + ALB for load balancing
- 🔐 Secure identity and access using IAM and OIDC

---

## 🧱 Key Features

- **Polyglot architecture**: Supports 11+ languages across microservices
- **Containerized builds**: Dockerized with best practices (multi-stage builds)
- **Infrastructure automation**: VPC, EKS, subnets, ALB setup via Terraform
- **Scalable deployment**: Kubernetes manifests for Deployments, Services, and Ingress
- **Custom domain routing**: DNS via Route 53 integrated with AWS Load Balancer
- **Monitoring & tracing**: OpenTelemetry SDKs for distributed tracing

---

## ⚙️ Technologies Used

| Category       | Tools/Tech Stack                         |
|----------------|------------------------------------------|
| CI/CD          | GitHub Actions, ArgoCD                   |
| Containerization | Docker, Docker Compose                |
| Orchestration  | Kubernetes (EKS), Helm, Ingress (ALB)    |
| Cloud          | AWS (EKS, EC2, Route 53, IAM, OIDC)      |
| Infrastructure | Terraform (with modules, S3 backend)     |
| Observability  | OpenTelemetry, OTLP exporters            |
| Languages      | Go, Java, Python, Node.js, etc.          |

---

## 🔄 CI/CD Pipeline

- **CI** (GitHub Actions):
  - Lint and unit test services
  - Build Docker images
  - Push to container registry (e.g., Docker Hub)

- **CD** (Argo CD):
  - Detects manifest changes
  - Syncs updated microservice image tags to EKS

---

## 🌐 Accessing the App

Once deployed:
- All services are exposed via a unified **Ingress ALB**
- DNS and domain routing managed through **AWS Route 53**
- Optional: use custom domain (e.g., `www.mmsalmanfaris.engineer`)

---

## 📎 Related Resources

- [OpenTelemetry](https://opentelemetry.io/)
- [AWS EKS](https://docs.aws.amazon.com/eks/)
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [Docker Documentation](https://docs.docker.com/)
- [Argo CD](https://argo-cd.readthedocs.io/)

---

## 📜 License

Apache 2.0 © [OpenTelemetry Authors](https://github.com/open-telemetry/opentelemetry-demo)

---



