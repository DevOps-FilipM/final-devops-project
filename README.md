# Final DevOps Project

## 📋 Opis projektu

Projekt dyplomowy demonstrujący kompletny pipeline DevOps dla aplikacji webowej Todo App opartej na Node.js. Projekt obejmuje automatyzację infrastruktury, CI/CD, oraz monitoring.

## 🏗️ Architektura
```
Developer (Git Push)
      ↓
GitHub Actions (CI/CD)
      ↓
Docker Hub (Rejestr obrazów)
      ↓
AWS EC2 (Serwer produkcyjny)
      ↓
Prometheus + Grafana (Monitoring)
```

## 🛠️ Stos technologiczny

| Kategoria | Technologia |
|-----------|-------------|
| Aplikacja | Node.js + Express |
| Konteneryzacja | Docker |
| Rejestr obrazów | Docker Hub |
| Infrastruktura (IaC) | Terraform |
| Chmura | AWS EC2 |
| CI/CD | GitHub Actions |
| Powiadomienia | Gmail SMTP |
| Monitoring | Prometheus + Grafana |
| Wersjonowanie | Git + GitHub |

## 📁 Struktura projektu
```
final-devops-project/
├── app/                          # Kod źródłowy aplikacji
│   ├── index.js                  # Główny plik aplikacji
│   ├── package.json              # Zależności Node.js
│   └── Dockerfile                # Definicja obrazu Docker
├── terraform/                    # Infrastruktura jako kod
│   ├── main.tf                   # Konfiguracja providera i backendu
│   ├── variables.tf              # Zmienne
│   ├── outputs.tf                # Outputy
│   ├── vpc.tf                    # Sieć VPC
│   ├── security.tf               # Security Groups
│   └── ec2.tf                    # Instancja EC2
├── monitoring/                   # Konfiguracja monitoringu
│   ├── prometheus.yml            # Konfiguracja Prometheusa
│   └── docker-compose.yml        # Stack monitoringowy
├── .github/
│   └── workflows/
│       └── ci-cd.yml             # Pipeline CI/CD
└── README.md                     # Dokumentacja
```

## 🚀 Wdrożenie infrastruktury od zera

### Wymagania
- AWS CLI skonfigurowane (`aws configure`)
- Terraform >= 1.0
- Docker
- Konto Docker Hub

### Krok 1 — Utwórz S3 bucket dla stanu Terraform
```bash
aws s3api create-bucket \
  --bucket devops-terraform-state-fmagiera \
  --region eu-central-1 \
  --create-bucket-configuration LocationConstraint=eu-central-1
```

### Krok 2 — Wdróż infrastrukturę
```bash
cd terraform
terraform init
terraform apply
```

### Krok 3 — Uruchom monitoring na EC2
```bash
ssh -i ~/.ssh/id_ed25519 ec2-user@<EC2_IP>
mkdir -p ~/monitoring
# Skopiuj pliki z katalogu monitoring/
docker-compose up -d
```

## ⚙️ CI/CD Pipeline

### Każdy commit (każda gałąź)
1. Budowanie obrazu Docker
2. Publikacja obrazu na Docker Hub z tagiem SHA commita

### Commit do gałęzi main
1. Budowanie obrazu Docker
2. Publikacja obrazu na Docker Hub
3. Automatyczny deployment na EC2
4. Weryfikacja health checka
5. Powiadomienie email o wyniku

## 🔌 API Endpoints

| Metoda | Endpoint | Opis |
|--------|----------|------|
| GET | `/health` | Health check aplikacji |
| GET | `/todos` | Lista wszystkich zadań |
| POST | `/todos` | Dodanie nowego zadania |
| PUT | `/todos/:id` | Zmiana statusu zadania |
| DELETE | `/todos/:id` | Usunięcie zadania |

## 📊 Monitoring

| Serwis | URL | Opis |
|--------|-----|------|
| Aplikacja | `http://<EC2_IP>:3000` | Todo App |
| Prometheus | `http://<EC2_IP>:9090` | Metryki |
| Grafana | `http://<EC2_IP>:3001` | Dashboardy (admin/devops123) |

## 🔒 Bezpieczeństwo

- Klucze SSH do autoryzacji na EC2
- Sekrety przechowywane w GitHub Secrets
- Stan Terraform szyfrowany w S3
- AWS IAM z zasadą najmniejszych uprawnień

## 💰 Koszty

Projekt wykorzystuje wyłącznie zasoby AWS Free Tier:
- EC2 t3.micro — 750h/miesiąc (darmowe przez 12 miesięcy)
- S3 — 5GB (darmowe)
- Wszystkie pozostałe zasoby — darmowe
