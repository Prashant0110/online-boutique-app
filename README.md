# online-boutique-cicd

**Author:** Prashant Raj Sapkota
**Part of:** Apex AI Arabia Cloud / DevOps Engineer Assessment

This is the **application repository**. It holds the Google Online Boutique source for the two services taken through the assessment's delivery path, plus the GitHub Actions workflows that build, scan, publish and promote them.

The full documentation (architecture, assumptions, review instructions, evidence, AI disclosure) is in the main submission README. The deployment state lives in the companion repository **`google-boutique-gitops`**.

## What is in this repository

| Path | Purpose |
|---|---|
| `.github/workflows/ci.yml` | Detect changed services, test, scan, build, publish to ECR, open a promotion pull request |
| `.github/workflows/rollback.yml` | Manual rollback: validates a previous commit SHA, checks the image exists in ECR, opens a rollback pull request |
| `Dockerfile`, `*.go`, `templates/`, `static/` | `frontend` service (Go) |
| `paymentservice/` | `paymentservice` (Node.js) and its Dockerfile |

## Pipeline in one view

1. A pull request or push to `main` triggers change detection, so only changed services build.
2. `frontend`: `go test`, `go vet`, `govulncheck`. `paymentservice`: `npm audit` and service validation.
3. Docker build and **Trivy** image scan.
4. Push to **ECR**, tagged with the commit SHA. Tags are immutable, and AWS access uses **GitHub OIDC** (no static keys).
5. On `main`, a promotion job opens a pull request in `google-boutique-gitops` updating the image tag. A person reviews and merges it, and Argo CD syncs the change.
6. Rollback is the manual `rollback.yml` workflow, which opens a reviewed pull request with a previous SHA.

## Run the application checks locally

```bash
go test ./... && go vet ./... && govulncheck ./...
cd paymentservice && npm ci && npm audit
```

## Workflow settings

The AWS account ID, region and IAM role are set in the workflow `env` block. The GitOps token is stored as a repository secret. No credentials are committed to this repository.
