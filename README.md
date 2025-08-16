# 🚀 N8N Docker Stack with Auto SSL

*Production-ready n8n automation platform with PostgreSQL, Redis, Nginx Proxy, and automatic Let's Encrypt SSL certificates*

---

## 📋 Table of Contents

- [🌐 Language / Bahasa](#-language--bahasa)
- [📖 English Documentation](#-english-documentation)
  - [Overview](#overview)
  - [Prerequisites](#prerequisites)
  - [Quick Start](#quick-start)
  - [Configuration](#configuration)
  - [Authentication](#authentication)
  - [Database Operations](#database-operations)
  - [Troubleshooting](#troubleshooting)
- [📖 Dokumentasi Bahasa Indonesia](#-dokumentasi-bahasa-indonesia)
  - [Ikhtisar](#ikhtisar)
  - [Persyaratan](#persyaratan)
  - [Panduan Cepat](#panduan-cepat)
  - [Konfigurasi](#konfigurasi)
  - [Autentikasi](#autentikasi)
  - [Operasi Database](#operasi-database)
  - [Pemecahan Masalah](#pemecahan-masalah)

---

## 🌐 Language / Bahasa

**🇺🇸 English** | **🇮🇩 Indonesia**

Choose your preferred language for documentation:
- **English**: Continue reading below
- **Bahasa Indonesia**: [Jump to Indonesian docs](#-dokumentasi-bahasa-indonesia)

---

# 📖 English Documentation

## Overview

This repository provides a complete **n8n automation platform** deployed via Docker Compose with:

- 🗃️ **PostgreSQL** - Reliable database backend
- 🚄 **Redis** - High-performance caching
- 🌐 **Nginx Proxy** - Reverse proxy with Cloudflare support
- 🔒 **Let's Encrypt** - Automatic SSL certificate management

### 📁 Repository Structure

```
📦 n8n-docker/
├── 📄 .env.example       # Environment variables template
├── 🐳 docker-compose.yml # Docker services configuration
├── ⚙️  nginx-proxy.conf   # Nginx proxy settings (Cloudflare real IP)
├── 💾 backup.sh          # Database backup/restore scripts
└── 📚 README.txt         # This documentation
```

## Prerequisites

Before you begin, ensure you have:

- ✅ **Docker** (v20.10+)
- ✅ **Docker Compose** (v2.0+)
- ✅ **Domain name** with DNS A/AAAA record pointing to your server
- ✅ **Ports 80 & 443** available on your server

> 💡 **Note**: Cloudflare proxy is supported and recommended for additional security.

## Quick Start

### Step 1: Environment Setup

Copy the environment template and configure your settings:

```bash
# Copy template
cp .env.example .env

# Edit configuration
nano .env
```

### Step 2: Environment Configuration

Update your `.env` file with secure values:

```env
# Database Configuration
DB_NAME=n8n
DB_USER=n8n
DB_PASSWORD=your_super_strong_password_here

# n8n Authentication
N8N_BASIC_AUTH_USER=admin
N8N_BASIC_AUTH_PASSWORD=another_strong_password

# Domain & SSL
DOMAIN=automation.yourdomain.com
LETSENCRYPT_EMAIL=admin@yourdomain.com
```

### Step 3: Deploy the Stack

```bash
# Start all services in background
docker-compose up -d

# Verify deployment
docker ps

# Check logs (optional)
docker-compose logs -f
```

### Step 4: Access Your n8n Instance

Once deployed, access your n8n instance at:

🌐 **https://automation.yourdomain.com**

## Configuration

### Recommended n8n Service Environment

Ensure your `docker-compose.yml` includes these optimized settings:

```yaml
environment:
  - DB_TYPE=postgresdb
  - DB_POSTGRESDB_HOST=postgres
  - DB_POSTGRESDB_PORT=5432
  - DB_POSTGRESDB_DATABASE=${DB_NAME}
  - DB_POSTGRESDB_USER=${DB_USER}          # ⚠️ Single '=' only
  - DB_POSTGRESDB_PASSWORD=${DB_PASSWORD}
  - N8N_BASIC_AUTH_ACTIVE=true
  - N8N_BASIC_AUTH_USER=${N8N_BASIC_AUTH_USER}
  - N8N_BASIC_AUTH_PASSWORD=${N8N_BASIC_AUTH_PASSWORD}
  - WEBHOOK_URL=https://${DOMAIN}
  - N8N_EDITOR_BASE_URL=https://${DOMAIN}
  - GENERIC_TIMEZONE=Asia/Jakarta
  - TZ=Asia/Jakarta
  - NODE_ENV=production
  - VIRTUAL_HOST=${DOMAIN}
  - LETSENCRYPT_HOST=${DOMAIN}
  - LETSENCRYPT_EMAIL=${LETSENCRYPT_EMAIL}
```

### Important Configuration Notes

- ⚠️ **Database User**: Use single `=` for `DB_POSTGRESDB_USER`
- 🔒 **Security**: Remove `POSTGRES_HOST_AUTH_METHOD=trust` when using strong passwords
- 🩺 **Health Check**: Configure PostgreSQL health check to use environment variables

## Authentication

Your n8n instance is protected with HTTP Basic Authentication:

- **Username**: Value from `N8N_BASIC_AUTH_USER`
- **Password**: Value from `N8N_BASIC_AUTH_PASSWORD`

## Database Operations

### 💾 Backup Database

**Linux/macOS:**
```bash
docker exec -t n8n-docker-postgres-1 pg_dump -U n8n -d n8n > backup_$(date +%Y%m%d_%H%M%S).sql
```

**Windows PowerShell:**
```powershell
docker exec -t n8n-docker-postgres-1 pg_dump -U n8n -d n8n | Out-File -FilePath "backup_$(Get-Date -Format 'yyyyMMdd_HHmmss').sql" -Encoding ascii
```

### 🔄 Restore Database

**Linux/macOS:**
```bash
cat backup.sql | docker exec -i n8n-docker-postgres-1 psql -U n8n -d n8n
```

**Windows PowerShell:**
```powershell
Get-Content backup.sql | docker exec -i n8n-docker-postgres-1 psql -U n8n -d n8n
```

## Troubleshooting

### 🚫 Port Conflicts (80/443 already in use)

Check which services are using the ports:
```bash
sudo lsof -i :80 -sTCP:LISTEN
sudo lsof -i :443 -sTCP:LISTEN
```

Stop conflicting services and restart Docker containers:
```bash
sudo systemctl stop apache2  # or nginx
docker-compose down && docker-compose up -d
```

### 🔒 SSL Certificate Issues

- ✅ Verify DNS A/AAAA records point to your server
- ✅ Ensure ports 80 and 443 are open in firewall
- ✅ Wait 5-10 minutes for certificate generation

### 🔐 Login Problems

Verify authentication credentials and restart n8n:
```bash
# Check environment variables
cat .env | grep N8N_BASIC_AUTH

# Restart n8n service
docker-compose restart n8n
```

### 📋 View Logs

Monitor different services:
```bash
# n8n application logs
docker-compose logs -f n8n

# Nginx proxy logs
docker-compose logs -f nginx-proxy

# Let's Encrypt logs
docker-compose logs -f letsencrypt

# All services
docker-compose logs -f
```

---

# 📖 Dokumentasi Bahasa Indonesia

## Ikhtisar

Repository ini menyediakan **platform otomasi n8n** lengkap yang di-deploy melalui Docker Compose dengan:

- 🗃️ **PostgreSQL** - Backend database yang handal
- 🚄 **Redis** - Caching berkinerja tinggi
- 🌐 **Nginx Proxy** - Reverse proxy dengan dukungan Cloudflare
- 🔒 **Let's Encrypt** - Manajemen sertifikat SSL otomatis

### 📁 Struktur Repository

```
📦 n8n-docker/
├── 📄 .env.example       # Template variabel environment
├── 🐳 docker-compose.yml # Konfigurasi layanan Docker
├── ⚙️  nginx-proxy.conf   # Pengaturan nginx proxy (Cloudflare real IP)
├── 💾 backup.sh          # Script backup/restore database
└── 📚 README.txt         # Dokumentasi ini
```

## Persyaratan

Sebelum memulai, pastikan Anda memiliki:

- ✅ **Docker** (v20.10+)
- ✅ **Docker Compose** (v2.0+)
- ✅ **Nama domain** dengan DNS A/AAAA record mengarah ke server
- ✅ **Port 80 & 443** tersedia di server Anda

> 💡 **Catatan**: Cloudflare proxy didukung dan direkomendasikan untuk keamanan tambahan.

## Panduan Cepat

### Langkah 1: Setup Environment

Salin template environment dan konfigurasi pengaturan Anda:

```bash
# Salin template
cp .env.example .env

# Edit konfigurasi
nano .env
```

### Langkah 2: Konfigurasi Environment

Perbarui file `.env` Anda dengan nilai yang aman:

```env
# Konfigurasi Database
DB_NAME=n8n
DB_USER=n8n
DB_PASSWORD=password_super_kuat_anda

# Autentikasi n8n
N8N_BASIC_AUTH_USER=admin
N8N_BASIC_AUTH_PASSWORD=password_kuat_lainnya

# Domain & SSL
DOMAIN=automation.domain-anda.com
LETSENCRYPT_EMAIL=admin@domain-anda.com
```

### Langkah 3: Deploy Stack

```bash
# Start semua layanan di background
docker-compose up -d

# Verifikasi deployment
docker ps

# Cek logs (opsional)
docker-compose logs -f
```

### Langkah 4: Akses Instance n8n Anda

Setelah di-deploy, akses instance n8n Anda di:

🌐 **https://automation.domain-anda.com**

## Konfigurasi

### Environment Service n8n yang Direkomendasikan

Pastikan `docker-compose.yml` Anda menyertakan pengaturan yang dioptimalkan:

```yaml
environment:
  - DB_TYPE=postgresdb
  - DB_POSTGRESDB_HOST=postgres
  - DB_POSTGRESDB_PORT=5432
  - DB_POSTGRESDB_DATABASE=${DB_NAME}
  - DB_POSTGRESDB_USER=${DB_USER}          # ⚠️ Hanya satu '='
  - DB_POSTGRESDB_PASSWORD=${DB_PASSWORD}
  - N8N_BASIC_AUTH_ACTIVE=true
  - N8N_BASIC_AUTH_USER=${N8N_BASIC_AUTH_USER}
  - N8N_BASIC_AUTH_PASSWORD=${N8N_BASIC_AUTH_PASSWORD}
  - WEBHOOK_URL=https://${DOMAIN}
  - N8N_EDITOR_BASE_URL=https://${DOMAIN}
  - GENERIC_TIMEZONE=Asia/Jakarta
  - TZ=Asia/Jakarta
  - NODE_ENV=production
  - VIRTUAL_HOST=${DOMAIN}
  - LETSENCRYPT_HOST=${DOMAIN}
  - LETSENCRYPT_EMAIL=${LETSENCRYPT_EMAIL}
```

### Catatan Konfigurasi Penting

- ⚠️ **Database User**: Gunakan satu `=` untuk `DB_POSTGRESDB_USER`
- 🔒 **Keamanan**: Hapus `POSTGRES_HOST_AUTH_METHOD=trust` saat menggunakan password kuat
- 🩺 **Health Check**: Konfigurasi PostgreSQL health check menggunakan variabel environment

## Autentikasi

Instance n8n Anda dilindungi dengan HTTP Basic Authentication:

- **Username**: Nilai dari `N8N_BASIC_AUTH_USER`
- **Password**: Nilai dari `N8N_BASIC_AUTH_PASSWORD`

## Operasi Database

### 💾 Backup Database

**Linux/macOS:**
```bash
docker exec -t n8n-docker-postgres-1 pg_dump -U n8n -d n8n > backup_$(date +%Y%m%d_%H%M%S).sql
```

**Windows PowerShell:**
```powershell
docker exec -t n8n-docker-postgres-1 pg_dump -U n8n -d n8n | Out-File -FilePath "backup_$(Get-Date -Format 'yyyyMMdd_HHmmss').sql" -Encoding ascii
```

### 🔄 Restore Database

**Linux/macOS:**
```bash
cat backup.sql | docker exec -i n8n-docker-postgres-1 psql -U n8n -d n8n
```

**Windows PowerShell:**
```powershell
Get-Content backup.sql | docker exec -i n8n-docker-postgres-1 psql -U n8n -d n8n
```

## Pemecahan Masalah

### 🚫 Konflik Port (80/443 sudah digunakan)

Periksa layanan mana yang menggunakan port:
```bash
sudo lsof -i :80 -sTCP:LISTEN
sudo lsof -i :443 -sTCP:LISTEN
```

Hentikan layanan yang konflik dan restart container Docker:
```bash
sudo systemctl stop apache2  # atau nginx
docker-compose down && docker-compose up -d
```

### 🔒 Masalah Sertifikat SSL

- ✅ Verifikasi DNS A/AAAA record mengarah ke server Anda
- ✅ Pastikan port 80 dan 443 terbuka di firewall
- ✅ Tunggu 5-10 menit untuk generasi sertifikat

### 🔐 Masalah Login

Verifikasi kredensial autentikasi dan restart n8n:
```bash
# Periksa variabel environment
cat .env | grep N8N_BASIC_AUTH

# Restart layanan n8n
docker-compose restart n8n
```

### 📋 Lihat Logs

Monitor layanan yang berbeda:
```bash
# Log aplikasi n8n
docker-compose logs -f n8n

# Log nginx proxy
docker-compose logs -f nginx-proxy

# Log Let's Encrypt
docker-compose logs -f letsencrypt

# Semua layanan
docker-compose logs -f
```

---

## 📞 Support & Contributing

- 🐛 **Issues**: Report bugs or request features
- 💬 **Discussions**: Share your experience and get help
- 🤝 **Contributions**: Pull requests are welcome
