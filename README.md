# aman-singh73_task-api-01

## Description
This project was generated and configured by InfrIQa.

## Prerequisites
- Node.js 20 LTS
- npm
- Docker and Docker Compose (optional)
- Git

## Setup
1. Clone the repository
2. Install dependencies: `npm install`
3. Copy environment variables: `cp .env.example .env` and fill in values
4. Run: `npm start`

## Docker
```bash
docker-compose up --build
```

## CI/CD
This project uses GitHub Actions workflows in `.github/workflows/`.
- `infriqa-ci.yml` — runs on every push (lint, test, build)
- `infriqa.yml` — deploys to Azure on merge to main branch

## Project Structure
See the repository root for service directories.
