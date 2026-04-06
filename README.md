# ⚧ TRANSDEVS - Setup Linux Automático

> **Script de configuração automática multi-distro para ambiente de desenvolvimento completo**

<div align="center">

![Bash](https://img.shields.io/badge/Bash-Script-4EAA25?style=for-the-badge&logo=gnu-bash&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-blue?style=for-the-badge)
![Version](https://img.shields.io/badge/Version-2.0-orange?style=for-the-badge)
![Platform](https://img.shields.io/badge/Platform-Linux-2D9CDB?style=for-the-badge&logo=linux&logoColor=white)

**Ubuntu/Debian** • **Fedora/RHEL/Alma/Rocky** • **Arch/Manjaro** • **openSUSE**

</div>

---

## 📋 Índice

- [Visão Geral](#-visão-geral)
- [Funcionalidades](#-funcionalidades)
- [Distribuições Suportadas](#-distribuições-suportadas)
- [Requisitos](#-requisitos)
- [Instalação](#-instalação)
- [Uso](#-uso)
- [O que é Instalado](#-o-que-é-instalado)
- [Detecção Automática](#-detecção-automática)
- [Validação de Versão Inteligente](#-validação-de-versão-inteligente)
- [Logs](#-logs)
- [Segurança](#-segurança)
- [Contribuindo](#-contribuindo)
- [Créditos](#-créditos)
- [Licença](#-licença)

---

## 🌟 Visão Geral

O **TRANSDEVS Setup** é um script bash automatizado que configura completamente um ambiente de desenvolvimento Linux com um único comando. Ele detecta automaticamente sua distribuição Linux e adapta-se para instalar todas as ferramentas e dependências necessárias para desenvolvimento de software.

### Por que usar?

- ✅ **100% automatizado** - Sem intervenção manual necessária
- ✅ **Multi-distro inteligente** - Detecta e adapta-se automaticamente
- ✅ **Validação de versão** - Corrige incompatibilidades de pacotes automaticamente
- ✅ **Idempotente** - Pode ser executado múltiplas vezes com segurança
- ✅ **Logging completo** - Todo processo é registrado para auditoria
- ✅ **Bancos de dados inclusos** - MySQL, PostgreSQL, MongoDB pré-configurados

---

## 🚀 Funcionalidades

### Automação Completa
- Detecção automática de distribuição Linux
- Validação inteligente de versões compatíveis
- Correção automática de repositórios inválidos
- Instalação adaptativa baseada no gerenciador de pacotes

### Ambiente de Desenvolvimento
- **Languages**: Java, Node.js, Python, .NET, Go
- **Databases**: MariaDB, PostgreSQL, MongoDB, Redis, SQLite
- **Tools**: Git, Docker, Kubernetes, Terraform
- **IDEs**: VS Code com extensões pré-configuradas
- **Browsers**: Google Chrome

### Configurações Extras
- Locale e timezone brasileiros
- Drivers NVIDIA configurados
- Docker com permissões de usuário
- Credenciais de bancos de dados documentadas

---

## 🐧 Distribuições Suportadas

| Família | Distribuições | Gerenciador |
|---------|--------------|-------------|
| **Debian** | Ubuntu, Linux Mint, Pop!_OS, Zorin, Elementary | `apt` |
| **RHEL** | Fedora, RHEL, AlmaLinux, Rocky, CentOS | `dnf`/`yum` |
| **Arch** | Arch, Manjaro, EndeavourOS, Garuda | `pacman` |
| **SUSE** | openSUSE Leap/Tumbleweed, SLES | `zypper` |

### Mapeamento de Versões Inteligente

O script corrige automaticamente incompatibilidades de versão:

| Ubuntu Detectado | LTS Usada | Codename |
|-----------------|-----------|----------|
| 25.10 (Questing) | 24.04 | noble |
| 24.10 (Oracular) | 24.04 | noble |
| 24.04 (Noble) | 24.04 | noble |
| 23.04 (Lunar) | 22.04 | jammy |
| 22.10 (Kinetic) | 22.04 | jammy |
| 22.04 (Jammy) | 22.04 | jammy |

---

## 📦 Requisitos

- **Sistema**: Linux (Ubuntu/Debian, Fedora/RHEL, Arch/Manjaro, openSUSE)
- **Permissões**: Root (via `sudo`)
- **Espaço em disco**: ~5GB recomendados
- **Memória RAM**: 4GB mínimos, 8GB recomendados
- **Internet**: Conexão ativa para download de pacotes

---

## 💾 Instalação

### Método 1: Download Direto

```bash
# Baixar o script
wget https://raw.githubusercontent.com/rafaela/Setup-Linux-TransDevs/main/Setup-Linux-TransDevs.sh

# Dar permissão de execução
chmod +x Setup-Linux-TransDevs.sh

# Executar com sudo
sudo bash Setup-Linux-TransDevs.sh
```

### Método 2: Clonar Repositório

```bash
# Clonar o repositório
git clone https://github.com/rafaela/Setup-Linux-TransDevs.git

# Entrar no diretório
cd Setup-Linux-TransDevs

# Executar o script
sudo bash Setup-Linux-TransDevs.sh
```

### Método 3: One-Liner

```bash
# Executar diretamente (sem salvar arquivo)
wget -qO- https://raw.githubusercontent.com/rafaela/Setup-Linux-TransDevs/main/Setup-Linux-TransDevs.sh | sudo bash
```

### Método 4: Com Senha Automatizada

```bash
# Para execução sem prompt de senha
echo "sua_senha_aqui" | sudo -S bash Setup-Linux-TransDevs.sh
```

---

## 🎯 Uso

### Execução Padrão

```bash
sudo bash Setup-Linux-TransDevs.sh
```

### Execução com Senha Automatizada

```bash
echo "SUA_SENHA" | sudo -S bash Setup-Linux-TransDevs.sh
```

### Verificar Logs

```bash
# Logs são salvos na Área de Trabalho
ls ~/Área\ de\ Trabalho/Setup-Linux-TransDevs-*.log

# Ou no Desktop (inglês)
ls ~/Desktop/Setup-Linux-TransDevs-*.log

# Ver último log
tail -f ~/Área\ de\ Trabalho/Setup-Linux-TransDevs-*.log
```

---

## 🛠️ O que é Instalado

### 1. 🔧 Ferramentas de Desenvolvimento
```
Git, Git LFS, Curl, Wget, Zip, Unzip, P7Zip
Htop, Net Tools, Netcat, JQ, Tree, Vim, Nano
Tmux, Screen, Build-Essential, CMake, GCC/G++
PKG-Config, Autoconf, Automake, Libtool, Make
GDB, Valgrind, Strace, Sysstat, Iotop
```

### 2. ☕ Java Development Kit
```
OpenJDK (LTS mais recente: 25, 24, 23 ou 21)
Maven
Gradle
JAVA_HOME configurado automaticamente
```

### 3. 🟢 Node.js & NPM
```
Node.js (LTS mais recente via NodeSource)
NPM
Yarn (se disponível)
```

### 4. 🐍 Python
```
Python3
Pip3
Venv, Dev, Tkinter
```

### 5. 🔷 .NET SDK
```
.NET SDK (9.0, 8.0 ou LTS mais recente)
Fallback via script oficial se indisponível
```

### 6. 🐳 Docker & Containers
```
Docker CE
Docker Compose
Usuário adicionado ao grupo docker
```

### 7. 🗄️ Bancos de Dados

#### MariaDB/MySQL
```
MariaDB Server
Usuário criado com permissões
Credenciais: ~/.db-credentials/mariadb.conf
```

#### PostgreSQL
```
PostgreSQL Server
Usuário e banco criados
Credenciais: ~/.db-credentials/postgresql.conf
```

#### MongoDB
```
MongoDB Shell (mongosh)
Repositório configurado com LTS compatível
```

#### Outros
```
Redis Server & CLI
SQLite3
DBeaver Community (IDE de banco de dados)
```

### 8. 🗜️ Microsoft SQL Server Tools
```
MS ODBC Driver 18
unixodbc-dev
ACCEPT_EULA=Y configurado
```

### 9. 🌐 Google Chrome
```
Google Chrome Stable
Repositório configurado
```

### 10. 💻 VS Code
```
Visual Studio Code
Repositório configurado
```

### 11. 🎮 Drivers NVIDIA
```
NVIDIA Driver (versão mais recente)
NVIDIA Utils
CUDA Toolkit (se disponível)
```

### 12. ☸️ DevOps & Cloud
```
Kubectl
Helm
Minikube
Terraform
AWS CLI
Azure CLI
```

### 13. 🔧 Ajustes do Sistema
```
Locale pt_BR.UTF-8
Timezone America/Sao_Paulo
Limpeza automática de pacotes
Remoção de repositórios inválidos
```

---

## 🔍 Detecção Automática

O script detecta automaticamente:

```bash
✅ Distribuição (Ubuntu, Fedora, Arch, etc.)
✅ Família (debian, rhel, arch, suse)
✅ Versão do sistema operacional
✅ Codename de lançamento
✅ Gerenciador de pacotes (apt, dnf, pacman, zypper)
✅ Arquitetura (x86_64, aarch64)
✅ CPU e GPU
✅ Memória RAM e Disco
✅ Usuário atual
```

### Exemplo de Detecção

```
========================================
 DETECÇÃO DO SISTEMA
========================================

Distribuição: Ubuntu 25.10
ID: ubuntu
Family: debian
Versão: 25.10
Codename: questing
Gerenciador de Pacotes: apt
Arquitetura: x86_64
Kernel: 6.17.0-20-generic
Hostname: RAFA-PC

CPU: Intel(R) Core(TM) i7-10700K
GPU: NVIDIA Corporation GA106 [GeForce RTX 3060]
RAM: 14Gi
Disco: 238G
Usuário: rafaela

[OK] Distribuição 'ubuntu' (debian) detectada e suportada!
```

---

## 🧠 Validação de Versão Inteligente

### Problema Resolvido

Distribuições como Ubuntu lançam versões intermediárias (ex: 25.10 "questing") que **não são suportadas** por repositórios de terceiros como:
- ❌ Microsoft Packages
- ❌ MongoDB Repository
- ❌ HashiCorp Releases
- ❌ Docker CE (em alguns casos)

### Solução Implementada

O script corrige automaticamente usando **funções de mapeamento LTS**:

```bash
get_lts_codename()          # Mapeia codename → LTS (questing → noble)
get_lts_version()           # Retorna versão LTS (25.10 → 24.04)
get_rhel_microsoft_version() # Valida RHEL para Microsoft (8 ou 9)
get_sles_microsoft_version() # Valida SLES para Microsoft (12 ou 15)
get_opensuse_docker_version() # Valida openSUSE para Docker (15)
get_fedora_rpmfusion_version() # Valida Fedora para RPM Fusion (≥38)
```

### Limpeza Automática

O script **detecta e remove** repositórios inválidos de execuções anteriores:

```bash
✅ Remove repos com versão 25.10/questing
✅ Remove repos com codenames não suportados
✅ Recria repos com versões LTS compatíveis
✅ Atualiza lista de pacotes após limpeza
```

---

## 📝 Logs

### Localização

```bash
# Português (Brasil)
~/Área de Trabalho/Setup-Linux-TransDevs-YYYYMMDD_HHMMSS.log

# Inglês
~/Desktop/Setup-Linux-TransDevs-YYYYMMDD_HHMMSS.log
```

### Conteúdo do Log

```
✅ Todos os comandos executados
✅ Pacotes instalados com sucesso
✅ Avisos e erros tratados
✅ Informações do sistema detectadas
✅ Resumo final de instalação
```

---

## 🔒 Segurança

### Boas Práticas

- ✅ **Execução como root apenas quando necessário**
- ✅ **Chaves GPG verificadas para todos os repositórios**
- ✅ **HTTPS para todos os downloads**
- ✅ **Credenciais salvas com permissões restritas**
- ✅ **Sem hardcoding de senhas**
- ✅ **Logging completo para auditoria**

### Credenciais de Banco de Dados

```bash
# Arquivo de configuração seguro
~/.db-credentials/
├── mariadb.conf    # Credenciais MariaDB/MySQL
└── postgresql.conf # Credenciais PostgreSQL

# Permissões restritas
chmod 600 ~/.db-credentials/*.conf
```

---

## 🤝 Contribuindo

Contribuições são bem-vindas! Sinta-se à vontade para:

1. **Fork** o projeto
2. Crie uma **Branch** para sua feature (`git checkout -b feature/AmazingFeature`)
3. **Commit** suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. **Push** para a branch (`git push origin feature/AmazingFeature`)
5. Abra um **Pull Request**

### Reportando Bugs

Encontrou um bug? Abra uma issue em:
👉 [github.com/rafaela/Setup-Linux-TransDevs/issues](https://github.com/rafaela/Setup-Linux-TransDevs/issues)

### Solicitando Features

Tem uma ideia? Abra uma issue com a tag `enhancement`:
👉 [github.com/rafaela/Setup-Linux-TransDevs/issues](https://github.com/rafaela/Setup-Linux-TransDevs/issues)

---

## 👥 Créditos

### Criadora & Mantenedora

<div align="center">

| Autor | Role | GitHub |
|-------|------|--------|
| **Rafaela** | 🎨 Criadora do Projeto, Desenvolvedora Principal | [@rafaela](https://github.com/rafaela) |

</div>

### Assistência de Desenvolvimento

<div align="center">

| Assistente | Role | Tecnologia |
|-----------|------|------------|
| **Qwen Code** | 🤖 Assistente LLM - Desenvolvimento, Debug e Validação de Código | Qwen Code (Alibaba Group) |

</div>

### Agradecimentos Especiais

- 🙏 Comunidade **TransDevs** por inspirar este projeto
- 🐧 Comunidade **Linux** por manter o ecossistema vivo
- 🔧 Contribuidores de código aberto que tornam este script possível

---

## 📄 Licença

Este projeto está licenciado sob a **MIT License** - veja o arquivo [LICENSE](LICENSE) para detalhes.

### Resumo da Licença

```
✅ Uso comercial permitido
✅ Modificação permitido
✅ Distribuição permitido
✅ Uso privado permitido
⚠️  Sem garantia - use por sua conta e risco
```

---

## 📊 Estatísticas do Projeto

<div align="center">

![Stars](https://img.shields.io/github/stars/rafaela/Setup-Linux-TransDevs?style=social)
![Forks](https://img.shields.io/github/forks/rafaela/Setup-Linux-TransDevs?style=social)
![Issues](https://img.shields.io/github/issues/rafaela/Setup-Linux-TransDevs)
![Pull Requests](https://img.shields.io/github/issues-pr/rafaela/Setup-Linux-TransDevs)
![Last Commit](https://img.shields.io/github/last-commit/rafaela/Setup-Linux-TransDevs)

</div>

---

## 🔗 Links Úteis

- 📦 **Repositório**: [github.com/rafaela/Setup-Linux-TransDevs](https://github.com/rafaela/Setup-Linux-TransDevs)
- 🐛 **Reportar Bug**: [Issues](https://github.com/rafaela/Setup-Linux-TransDevs/issues)
- 📖 **Documentação**: Este README
- 💬 **Suporte**: Abra uma issue

---

<div align="center">

**Feito com ❤️ por Rafaela e comunidade TransDevs**

*Powered by Qwen Code (Alibaba Group)*

[⬆️ Voltar ao topo](#-transdevs---setup-linux-automático)

</div>
