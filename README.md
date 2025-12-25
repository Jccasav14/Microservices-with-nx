# SIBU Nx Monorepo + Terraform (AWS Academy: NO IAM)

Este repo está adaptado para AWS Academy/Learner Lab donde normalmente no se permite `iam:CreateRole`.

- No crea IAM roles/instance profiles
- No usa ECR
- Las EC2 (ASG) descargan el repo desde GitHub y construyen imágenes Docker al arrancar

Recomendado: repo público.

Swagger:
- http://<ALB_DNS>/api/auth/docs
- http://<ALB_DNS>/api/users/docs
- http://<ALB_DNS>/api/cases/docs
