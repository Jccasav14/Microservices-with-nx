# Nx Monorepo (Front + 3 microservicios) + Terraform AWS (TODO en código) + GitHub Actions (Lab STS)

✅ **No necesitas crear ECR ni KeyPair a mano.**  
✅ **No usa SSH ni llaves** (se elimina dependencia de `key_name` / `MY_IP_CIDR`).  
✅ **Terraform crea los repos ECR** y la infraestructura.  
✅ GitHub Actions usa **credenciales temporales del laboratorio** (STS):
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `AWS_SESSION_TOKEN`

> Nota: La región (`AWS_REGION`) no es credencial, pero se necesita. Puedes ponerla como secret o como env fija.

---

## Cómo funciona el pipeline (QA / PROD)
1) Workflow configura credenciales AWS (con token del Lab).  
2) Terraform aplica un **bootstrap** que crea **ECR repos** (solo una vez / idempotente).  
3) Se construyen imágenes Docker y se suben a ECR.  
4) Terraform aplica infraestructura:
   - ALB con rutas:
     - `/` → Front (ASG)
     - `/api/*` y `/health` → Back (ASG)
   - ASG Front (1 EC2)
   - ASG Back (1 EC2) (corre 3 microservicios + nginx)
   - EC2 fija DB (Postgres)
5) Swagger:
   - `http://<ALB_DNS>/api/auth/docs`
   - `http://<ALB_DNS>/api/users/docs`
   - `http://<ALB_DNS>/api/cases/docs`

---

## Secrets mínimos (AWS Academy / Learner Lab)
En GitHub → Settings → Secrets → Actions:

- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `AWS_SESSION_TOKEN`
- (recomendado) `AWS_REGION` (ej: `us-east-1`)

⚠️ En Labs el token expira. Si falla el pipeline, renuevas credenciales y actualizas secrets.

---

## Ejecutar local (opcional)
```bash
npm install
docker compose up --build
```
- Front: http://localhost/
- Swagger: http://localhost/api/auth/docs

---
