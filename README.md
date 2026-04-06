# ⚧ TRANSDEVS - Setup Linux Automático

> **Script de configuração automática multi-distro para ambiente de desenvolvimento completo**

<div align="center">

![Bash](https://img.shields.io/badge/Bash-Script-4EAA25?style=for-the-badge&logo=gnu-bash&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-blue?style=for-the-badge)
![Version](https://img.shields.io/badge/Version-2.0-orange?style=for-the-badge)
![Platform](https://img.shields.io/badge/Platform-Linux-2D9CDB?style=for-the-badge&logo=linux&logoColor=white)
![Status](https://img.shields.io/badge/Status-Produção-brightgreen?style=for-the-badge)
![Forks](https://img.shields.io/badge/Forks-Bem--vindos!-purple?style=for-the-badge)

**Ubuntu/Debian** • **Fedora/RHEL/Alma/Rocky** • **Arch/Manjaro** • **openSUSE**

⭐ *Se este projeto te ajudou, considere dar uma estrela!*

</div>

---

## 📋 Índice

- [Visão Geral](#-visão-geral)
- [Funcionalidades](#-funcionalidades)
- [Distribuições Suportadas](#-distribuições-suportadas)
- [Requisitos](#-requisitos)
- [Instalação Rápida](#-instalação-rápida)
- [Instalação Detalhada](#-instalação-detalhada)
- [Uso](#-uso)
- [O que é Instalado](#-o-que-é-instalado)
- [Detecção Automática](#-detecção-automática)
- [Validação de Versão Inteligente](#-validação-de-versão-inteligente)
- [Bancos de Dados Configurados](#-bancos-de-dados-configurados)
- [Logs](#-logs)
- [Segurança](#-segurança)
- [Troubleshooting](#-troubleshooting)
- [Fork e Contribuição](#-fork-e-contribuição)
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
- ✅ **Open Source** - Forks e contribuições são bem-vindos!
- ✅ **Produção** - Testado e validado em Ubuntu 25.10+

### Destaques

| Recurso | Descrição |
|---------|-----------|
| 🎯 **Detecção Automática** | Identifica Ubuntu, Fedora, Arch, openSUSE e derivados |
| 🧠 **Validação LTS** | Corrige versões incompatíveis automaticamente |
| 🗄️ **DBs Configurados** | MariaDB, PostgreSQL, MongoDB prontos para uso |
| 🐳 **Docker Ready** | Docker CE + Compose + permissões configuradas |
| 🎮 **GPU NVIDIA** | Drivers e CUDA instalados automaticamente |
| ☁️ **Cloud Tools** | AWS CLI, Azure CLI, Terraform, K8s |
| 🔄 **Idempotente** | Reexecute sem medo - nada será quebrado |
| 📝 **Logs Detalhados** | Auditoria completa em arquivo de log |

### Fluxo de Execução

```
1. Detectar Sistema
   ↓
2. Limpar Repos Inválidos
   ↓
3. Atualizar Sistema
   ↓
4. Configurar Locale/Timezone
   ↓
5. Adicionar Repositórios
   ↓
6. Instalar Ferramentas Dev
   ↓
7. Instalar JDK, Node, Python, .NET
   ↓
8. Instalar Docker, DBs, Tools
   ↓
9. Configurar VS Code, Chrome
   ↓
10. Drivers NVIDIA
    ↓
11. DevOps & Cloud Tools
    ↓
12. Limpeza & Resumo Final
```

---

## 🚀 Funcionalidades

### Automação Completa
- ✅ Detecção automática de distribuição Linux
- ✅ Validação inteligente de versões compatíveis
- ✅ Correção automática de repositórios inválidos
- ✅ Instalação adaptativa baseada no gerenciador de pacotes
- ✅ Fallback automático para métodos alternativos de instalação
- ✅ Idempotente - execute múltiplas vezes sem riscos

### Ambiente de Desenvolvimento

| Categoria | Ferramentas Instaladas |
|-----------|----------------------|
| **Languages** | Java (OpenJDK 21-25), Node.js (LTS), Python 3, .NET SDK (6-9), Go |
| **Databases** | MariaDB, PostgreSQL, MongoDB, Redis, SQLite, SQL Server Tools |
| **DevOps** | Docker CE, Kubernetes (kubectl, helm, minikube), Terraform |
| **Cloud** | AWS CLI, Azure CLI |
| **IDEs** | VS Code (repositório oficial configurado) |
| **Browsers** | Google Chrome Stable |
| **System** | Git, Curl, Wget, Htop, Vim, Nano, Tmux, Build-Essential, CMake, GCC/G++ |
| **Debug** | GDB, Valgrind, Strace, Sysstat, Iotop, Nmap |

### Configurações Extras
- 🌍 **Locale** pt_BR.UTF-8 configurado
- 🕐 **Timezone** America/Sao_Paulo
- 🎮 **NVIDIA** Drivers + CUDA Toolkit
- 🐳 **Docker** Permissões configuradas (sem sudo)
- 🗄️ **Bancos** Credenciais documentadas em `~/.db-credentials/`
- 🧹 **Limpeza** Pacotes desnecessários removidos automaticamente
- 📊 **Relatório** Resumo final detalhado de tudo que foi instalado

---

## 🐧 Distribuições Suportadas

### Tabela Completa

| Família | Distribuições | Gerenciador | Status |
|---------|--------------|-------------|--------|
| **Debian** | Ubuntu, Linux Mint, Pop!_OS, Zorin, Elementary | `apt` | ✅ Total |
| **RHEL** | Fedora, RHEL, AlmaLinux, Rocky, CentOS | `dnf`/`yum` | ✅ Total |
| **Arch** | Arch, Manjaro, EndeavourOS, Garuda, CachyOS | `pacman` | ✅ Total |
| **SUSE** | openSUSE Leap/Tumbleweed, SLES | `zypper` | ✅ Total |

### Mapeamento de Versões Inteligente

O script corrige automaticamente incompatibilidades de versão para repositórios de terceiros:

#### Ubuntu → LTS

| Ubuntu Detectado | LTS Usada | Codename | Microsoft | MongoDB | HashiCorp |
|-----------------|-----------|----------|-----------|---------|-----------|
| 25.10 (Questing) | 24.04 | noble | ✅ | ✅ | ✅ |
| 24.10 (Oracular) | 24.04 | noble | ✅ | ✅ | ✅ |
| 24.04 (Noble) | 24.04 | noble | ✅ | ✅ | ✅ |
| 23.04 (Lunar) | 22.04 | jammy | ✅ | ✅ | ✅ |
| 22.10 (Kinetic) | 22.04 | jammy | ✅ | ✅ | ✅ |
| 22.04 (Jammy) | 22.04 | jammy | ✅ | ✅ | ✅ |

#### RHEL/Fedora → Microsoft

| Versão Detectada | Versão Microsoft | Notas |
|-----------------|------------------|-------|
| Fedora 41+ | 9 | Mais recente suportada |
| Fedora 38-40 | 9 | Compatível |
| RHEL 9.x | 9 | Suporte oficial |
| RHEL 8.x | 8 | Suporte oficial |
| < 8 | 8 | Fallback seguro |

#### openSUSE → Docker

| Versão Detectada | Versão Docker | Notas |
|-----------------|---------------|-------|
| 15.x | 15 | Suporte oficial |
| Tumbleweed | 15 | Fallback estável |
| < 15 | 15 | Fallback seguro |

---

## 📦 Requisitos

### Mínimos
- **Sistema**: Linux (Ubuntu/Debian, Fedora/RHEL, Arch/Manjaro, openSUSE)
- **Permissões**: Root (via `sudo`)
- **Espaço em disco**: ~2GB livres
- **Memória RAM**: 4GB
- **Internet**: Conexão ativa para download de pacotes

### Recomendados
- **Espaço em disco**: ~10GB livres (para instalação completa)
- **Memória RAM**: 8GB+
- **CPU**: Multi-core (para compilações e builds)
- **Swap**: 2GB+ (para operações intensivas)

### Tempo Estimado de Instalação
| Tipo de Instalação | Tempo Estimado |
|-------------------|----------------|
| Completa (primeira vez) | 15-45 min |
| Parcial (alguns itens já instalados) | 5-15 min |
| Reexecução (tudo já instalado) | 2-5 min |

---

## 💾 Instalação

> ⚠️ **Importante**: Este é um repositório público e open source. Forks são encorajados!

### ⚡ Método 1: One-Liner (Mais Rápido)

```bash
# Executar diretamente sem salvar arquivo
wget -qO- https://raw.githubusercontent.com/RafaelaCuoco/Setup-Linux-TransDevs/main/Setup-Linux-TransDevs.sh | sudo bash
```

### 📥 Método 2: Download Direto

```bash
# Baixar o script
wget https://raw.githubusercontent.com/RafaelaCuoco/Setup-Linux-TransDevs/main/Setup-Linux-TransDevs.sh

# Dar permissão de execução
chmod +x Setup-Linux-TransDevs.sh

# Executar com sudo
sudo bash Setup-Linux-TransDevs.sh
```

### 🔀 Método 3: Clonar Repositório (Recomendado para Contribuir)

```bash
# Clonar o repositório
git clone https://github.com/RafaelaCuoco/Setup-Linux-TransDevs.git

# Entrar no diretório
cd Setup-Linux-TransDevs

# Dar permissão de execução
chmod +x Setup-Linux-TransDevs.sh

# Executar o script
sudo bash Setup-Linux-TransDevs.sh
```

### 🔐 Método 4: Com Senha Automatizada

```bash
# Para execução sem prompt de senha (útil para CI/CD)
echo "sua_senha_aqui" | sudo -S bash Setup-Linux-TransDevs.sh
```

### 🎯 Método 5: Fork Personalizado

```bash
# 1. Fork do repositório no GitHub
# 2. Clone seu fork
git clone https://github.com/SEU_USUARIO/Setup-Linux-TransDevs.git
cd Setup-Linux-TransDevs

# 3. Personalize o script (adicione/remova pacotes)
vim Setup-Linux-TransDevs.sh

# 4. Execute sua versão
sudo bash Setup-Linux-TransDevs.sh

# 5. Contribua de volta com um PR!
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

> 💡 **Nota**: O script é idempotente. Se um pacote já estiver instalado, ele será verificado e mantido.

### 1. 🔧 Ferramentas de Desenvolvimento

| Categoria | Pacotes |
|-----------|---------|
| **Version Control** | Git, Git LFS |
| **Network** | Curl, Wget, Net Tools, Netcat (OpenBSD), Nmap, Traceroute |
| **Compression** | Zip, Unzip, P7Zip (Full/Plugins) |
| **System Monitor** | Htop, Sysstat, Iotop, Iftop, Ncdu |
| **Editors** | Vim, Nano, Tree |
| **Terminal Multiplexer** | Tmux, Screen |
| **Build Tools** | Build-Essential, GCC/G++, CMake, Pkg-config |
| **Build Systems** | Autoconf, Automake, Libtool, Make |
| **Debug/Profile** | GDB, Valgrind, Strace, Ltrace |
| **Network Utils** | Bind Utils (dig, nslookup), IP Utils (ping, ifconfig) |
| **File Transfer** | SSH, OpenSSH Server, Rsync |
| **Utilities** | JQ, Neofetch, DConf Editor, XDG Utils, Fonts (Noto, Emoji, CJK) |

### 2. ☕ Java Development Kit

| Componente | Detalhes |
|-----------|----------|
| **OpenJDK** | Versão LTS mais recente (25, 24, 23 ou 21) com fallback automático |
| **Maven** | Gerenciador de dependências e build |
| **Gradle** | Build automation tool |
| **JAVA_HOME** | Configurado automaticamente em `/etc/profile.d/java.sh` |
| **Validação** | `java -version`, `mvn -version`, `gradle -version` |

### 3. 🟢 Node.js & NPM

| Componente | Detalhes |
|-----------|----------|
| **Node.js** | LTS mais recente via NodeSource (22.x+) |
| **NPM** | Gerenciador de pacotes Node |
| **Repositório** | Nodesource configurado com versão LTS |
| **Fallback** | Script oficial se NodeSource falhar |
| **Validação** | `node -v`, `npm -v` |

### 4. 🐍 Python

| Componente | Detalhes |
|-----------|----------|
| **Python3** | Versão mais recente do repositório |
| **Pip3** | Gerenciador de pacotes Python |
| **Extras** | Venv, Dev, Tkinter, Distutils |
| **Validação** | `python3 --version`, `pip3 --version` |

### 5. 🔷 .NET SDK

| Componente | Detalhes |
|-----------|----------|
| **.NET SDK** | 9.0 → 8.0 → 7.0 → 6.0 (fallback automático) |
| **Repositório** | Microsoft configurado com LTS compatível |
| **Fallback** | Script oficial `dotnet-install.sh` |
| **Validação** | `dotnet --version` |

### 6. 🐳 Docker & Containers

| Componente | Detalhes |
|-----------|----------|
| **Docker CE** | Último versão via repositório oficial |
| **Docker Compose** | Plugin incluído |
| **Permissões** | Usuário adicionado ao grupo `docker` (sem sudo) |
| **Repositório** | Configurado com LTS compatível |
| **Validação** | `docker --version`, `docker compose version` |

### 7. 🗄️ Bancos de Dados

#### MariaDB/MySQL

| Componente | Detalhes |
|-----------|----------|
| **MariaDB Server** | Via repositório oficial MariaDB |
| **Cliente** | `mariadb` ou `mysql` CLI |
| **Usuário** | Criado automaticamente com seu usuário Linux |
| **Credenciais** | Salvas em `~/.db-credentials/mariadb.conf` |
| **Service** | Habilitado e iniciado automaticamente |

#### PostgreSQL

| Componente | Detalhes |
|-----------|----------|
| **PostgreSQL Server** | Versão mais recente do repositório |
| **Cliente** | `psql` CLI |
| **Usuário** | Role criado com seu usuário Linux |
| **Credenciais** | Salvas em `~/.db-credentials/postgresql.conf` |
| **Service** | Habilitado e iniciado automaticamente |

#### MongoDB

| Componente | Detalhes |
|-----------|----------|
| **MongoDB Shell** | `mongosh` via repositório oficial |
| **Repositório** | Configurado com LTS compatível |

#### Outros Bancos

| Banco | Pacote | Validação |
|-------|--------|-----------|
| **Redis** | Redis Server + CLI | `redis-cli ping` → PONG |
| **SQLite** | SQLite3 | `sqlite3 --version` |
| **DBeaver** | Community Edition (IDE) | `dbeaver-ce --version` |

### 8. 🗜️ Microsoft SQL Server Tools

| Componente | Detalhes |
|-----------|----------|
| **MS ODBC Driver** | Versão 18 (fallback para 17) |
| **unixodbc-dev** | Headers para desenvolvimento |
| **ACCEPT_EULA** | Configurado automaticamente (`Y`) |
| **Repositório** | Microsoft configurado com LTS compatível |

### 9. 🌐 Google Chrome

| Componente | Detalhes |
|-----------|----------|
| **Chrome** | Versão Stable mais recente |
| **Repositório** | Configurado para atualizações automáticas |

### 10. 💻 VS Code

| Componente | Detalhes |
|-----------|----------|
| **VS Code** | Último versão via repositório oficial |
| **Repositório** | Configurado para atualizações automáticas |

### 11. 🎮 Drivers NVIDIA

| Componente | Detalhes |
|-----------|----------|
| **NVIDIA Driver** | Versão mais recente disponível (550+) |
| **CUDA Toolkit** | Se disponível nos repositórios |
| **Utils** | nvidia-smi, settings |
| **⚠️ Nota** | **Requer reinício do sistema para ativar** |

### 12. ☸️ DevOps & Cloud Tools

| Ferramenta | Descrição | Validação |
|-----------|-----------|-----------|
| **Kubectl** | Kubernetes CLI | `kubectl version --client` |
| **Helm** | Kubernetes Package Manager | `helm version` |
| **Minikube** | Kubernetes Local | `minikube version` |
| **Terraform** | Infrastructure as Code | `terraform version` |
| **AWS CLI** | Amazon Web Services | `aws --version` |
| **Azure CLI** | Microsoft Azure | `az --version` |

### 13. 🔧 Ajustes do Sistema

| Configuração | Detalhes |
|--------------|----------|
| **Locale** | pt_BR.UTF-8 configurado e ativado |
| **Timezone** | America/Sao_Paulo (UTC-3) |
| **Limpeza** | Pacotes desnecessários removidos |
| **Repositórios** | Inválidos removidos e recriados corretamente |
| **Log** | Arquivo de log criado na Área de Trabalho |

---

## 🔍 Detecção Automática

O script detecta e exibe automaticamente todas as informações do sistema:

| Item Detectado | Exemplo | Comando |
|----------------|---------|---------|
| **Distribuição** | Ubuntu 25.10 | `/etc/os-release` |
| **Família** | debian, rhel, arch, suse | Lógica baseada em ID_LIKE |
| **Versão** | 25.10 | `VERSION_ID` |
| **Codename** | questing | `VERSION_CODENAME` |
| **Gerenciador** | apt, dnf, pacman, zypper | Detectado da família |
| **Arquitetura** | x86_64, aarch64 | `uname -m` |
| **Kernel** | 6.17.0-20-generic | `uname -r` |
| **CPU** | Intel i7-10700K | `lscpu` ou `/proc/cpuinfo` |
| **GPU** | NVIDIA RTX 3060 | `lspci` |
| **RAM** | 14Gi | `free -h` |
| **Disco** | 238G | `df -h /` |
| **Hostname** | RAFA-PC | `hostname` |
| **Usuário** | rafaela | `logname` ou `$SUDO_USER` |

### Exemplo de Output

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

CPU: 13th Gen Intel(R) Core(TM) i7-13700K
GPU: NVIDIA Corporation GA106 [GeForce RTX 3060]
RAM: 14Gi
Disco: 238G
Usuário: rafaela

[OK] Distribuição 'ubuntu' (debian) detectada e suportada!
```

---

## 🧠 Validação de Versão Inteligente

### O Problema

Distribuições Linux lançam versões intermediárias frequentemente (ex: Ubuntu 25.10 "questing"). Porém, repositórios de terceiros **não suportam essas versões** imediatamente:

| Repositório | Suporte | Problema |
|------------|---------|----------|
| ❌ **Microsoft Packages** | Apenas LTS | Sem suporte para 25.10/questing |
| ❌ **MongoDB** | Apenas LTS | 404 Not Found para questing |
| ❌ **HashiCorp** | Apenas LTS | Sem pacotes para versões intermediárias |
| ⚠️ **Docker CE** | Parcial | Pode não ter versão nova imediatamente |
| ⚠️ **RPM Fusion** | Fedora recente | Requer versão 38+ |

### A Solução: 6 Funções de Validação

O script implementa **funções inteligentes de mapeamento** para garantir compatibilidade:

| Função | O Que Faz | Exemplo de Mapeamento |
|--------|-----------|----------------------|
| **`get_lts_codename()`** | Mapeia codename → LTS | `questing` → `noble` |
| **`get_lts_version()`** | Retorna versão LTS | `25.10` → `24.04` |
| **`get_rhel_microsoft_version()`** | Valida RHEL Microsoft | `Fedora 41` → `9` |
| **`get_sles_microsoft_version()`** | Valida SLES Microsoft | `SLES 16` → `15` |
| **`get_opensuse_docker_version()`** | Valida openSUSE Docker | `Tumbleweed` → `15` |
| **`get_fedora_rpmfusion_version()`** | Valida Fedora RPM Fusion | `Fedora 37` → `38` |

### Limpeza Automática de Repos Inválidos

Na execução, o script **detecta e remove** repositórios inválidos de execuções anteriores:

```bash
✅ Verifica /etc/apt/sources.list.d/*.list
✅ Identifica codenames/versões inválidas (questing, 25.10, etc.)
✅ Remove arquivos de repositórios incompatíveis
✅ Recria repositórios com versões LTS corretas
✅ Atualiza lista de pacotes após limpeza
```

### Fluxo de Validação

```
1. Detectar Sistema
   ↓
2. Verificar repos existentes
   ↓
3. Tem repos inválidos? ──SIM──→ Remover
   ↓                               ↓
   NÃO                            Recriar com LTS
   ↓                               ↓
4. Continuar instalação ←─────────┘
```

---

## 🗄️ Bancos de Dados Configurados

### Credenciais Seguras

Todos os bancos de dados são configurados com credenciais salvas em local seguro:

```bash
~/.db-credentials/
├── mariadb.conf     # Usuário, senha, host, porta
└── postgresql.conf  # Usuário, senha, host, porta

# Permissões restritas (apenas dono lê/escreve)
chmod 600 ~/.db-credentials/*.conf
```

### MariaDB/MySQL

```bash
# Usuário do Linux criado como usuário MySQL
# Acesso local sem senha inicialmente
# Senha configurada em ~/.db-credentials/mariadb.conf

# Testar conexão:
mariadb -u $(whoami) -p
```

### PostgreSQL

```bash
# Role criado com seu usuário Linux
# Acesso via peer authentication
# Credenciais em ~/.db-credentials/postgresql.conf

# Testar conexão:
psql -U $(whoami) -d postgres
```

### MongoDB

```bash
# MongoDB Shell (mongosh) instalado
# Repositório configurado com LTS
# Pronto para conectar:

mongosh mongodb://localhost:27017
```

---

## 📝 Logs

### Localização dos Logs

Os logs são salvos automaticamente na sua Área de Trabalho:

```bash
# Português (Brasil)
~/Área\ de\ Trabalho/Setup-Linux-TransDevs-20260406_143022.log

# Inglês
~/Desktop/Setup-Linux-TransDevs-20260406_143022.log

# Nomeado com timestamp: AAAAMDD_HHMMSS
```

### O que é Logado

| Tipo | Exemplo | Cor |
|------|---------|-----|
| **[INFO]** | Instalação de pacotes | 🔵 Azul |
| **[OK]** | Sucesso na operação | 🟢 Verde |
| **[AVISO]** | Fallback ou aviso | 🟡 Amarelo |
| **[ERRO]** | Erro crítico | 🔴 Vermelho |

### Exemplo de Log

```
[INFO] Instalando: ferramentas de desenvolvimento
[OK] Ferramentas de desenvolvimento instaladas!

[INFO] Instalando OpenJDK (LTS mais recente)...
[INFO] Instalando: OpenJDK 25
[OK] Java instalado!

[AVISO] Script MariaDB falhou, tentando pacotes padrão...
[OK] Repositórios configurados!
```

### Visualizar Logs

```bash
# Listar todos os logs
ls -lh ~/Área\ de\ Trabalho/Setup-Linux-TransDevs-*.log

# Ver conteúdo de um log
cat ~/Área\ de\ Trabalho/Setup-Linux-TransDevs-20260406_143022.log

# Acompanhar em tempo real (durante execução)
tail -f ~/Área\ de\ Trabalho/Setup-Linux-TransDevs-*.log

# Buscar erros no log
grep "ERRO\|AVISO" ~/Área\ de\ Trabalho/Setup-Linux-TransDevs-*.log
```

---

## 🔒 Segurança
✅ Informações do sistema detectadas
✅ Resumo final de instalação
```

---

## 🔒 Segurança

### Boas Práticas Implementadas

| Prática | Descrição | Status |
|---------|-----------|--------|
| **Root Mínimo** | Execução como root apenas quando necessário | ✅ |
| **Chaves GPG** | Verificadas para todos os repositórios de terceiros | ✅ |
| **HTTPS** | Todos os downloads usam conexões seguras | ✅ |
| **Credenciais** | Salvas com permissões restritas (600) | ✅ |
| **Sem Senhas Hardcoded** | Credenciais geradas dinamicamente | ✅ |
| **Logging Completo** | Auditoria total em arquivo de log | ✅ |
| **Set -e** | Script para em caso de erro crítico | ✅ |
| **Fallbacks** | Múltiplos métodos para cada instalação | ✅ |

### O que o Script **NÃO** Faz

- ❌ Não envia dados para servidores externos
- ❌ Não modifica configurações de firewall
- ❌ Não desativa verificações de segurança
- ❌ Não instala pacotes de fontes não verificadas
- ❌ Não expõe portas de bancos de dados externamente
- ❌ Não coleta informações pessoais

### Transparência

O script é **100% open source** e auditável. Você pode revisar cada linha antes de executar:

```bash
# Revisar o script antes de executar
cat Setup-Linux-TransDevs.sh | less

# Verificar URLs de download
grep -E "curl|wget" Setup-Linux-TransDevs.sh

# Verificar repositórios adicionados
grep -E "deb |repo|ppa" Setup-Linux-TransDevs.sh
```

### Pós-Instalação Recomendado

```bash
# 1. Verificar serviços ativos
systemctl status docker mariadb postgresql

# 2. Verificar versões instaladas
docker --version
java -version
node -v
python3 --version

# 3. Testar bancos de dados
mariadb -u $(whoami) -p -e "SELECT 1;"
psql -U $(whoami) -d postgres -c "SELECT 1;"

# 4. Verificar credenciais
cat ~/.db-credentials/mariadb.conf
cat ~/.db-credentials/postgresql.conf

# 5. Testar Docker
docker run hello-world
```

---

## 🛠️ Troubleshooting

### Problemas Comuns

#### 1. Erro: "Repositório não está assinado"

**Causa:** Repositório de execução anterior com versão inválida

**Solução:**
```bash
# O script já corrige isso automaticamente!
# Mas manualmente:
sudo rm /etc/apt/sources.list.d/mssql-release.list
sudo rm /etc/apt/sources.list.d/mongodb-org-7.0.list
sudo apt update
```

#### 2. Erro: "404 Not Found" para MongoDB

**Causa:** Codename do Ubuntu não suportado pelo MongoDB

**Solução:**
```bash
# O script agora usa LTS automaticamente
# Verificar repositório correto:
cat /etc/apt/sources.list.d/mongodb-org-7.0.list
# Deve mostrar "noble" ao invés de "questing"
```

#### 3. Docker requer sudo

**Causa:** Usuário não adicionado ao grupo docker

**Solução:**
```bash
# O script adiciona automaticamente
# Mas para aplicar sem logout:
newgrp docker

# Ou fazer logout/login
```

#### 4. Drivers NVIDIA não ativados

**Causa:** Requer reinício do sistema

**Solução:**
```bash
# Reiniciar o sistema
sudo reboot

# Verificar após reinício
nvidia-smi
```

#### 5. Java não encontrado após instalação

**Causa:** Variável JAVA_HOME não carregada na sessão atual

**Solução:**
```bash
# Recarregar profile
source /etc/profile.d/java.sh

# Ou abrir novo terminal
java -version
```

### Log de Erro

Se algo falhar, verifique o log:

```bash
# Último log criado
ls -lt ~/Área\ de\ Trabalho/Setup-Linux-TransDevs-*.log | head -1

# Ver erros no log
grep "ERRO" ~/Área\ de\ Trabalho/Setup-Linux-TransDevs-*.log

# Ver avisos
grep "AVISO" ~/Área\ de\ Trabalho/Setup-Linux-TransDevs-*.log
```

### Suporte

Encontrou um problema não documentado?

1. **Verifique o log** em `~/Área de Trabalho/`
2. **Busque nas Issues**: [github.com/RafaelaCuoco/Setup-Linux-TransDevs/issues](https://github.com/RafaelaCuoco/Setup-Linux-TransDevs/issues)
3. **Abra uma nova Issue** com:
   - Sua distribuição (`cat /etc/os-release`)
   - Log completo do erro
   - Passos para reproduzir

---

## 🍴 Fork e Contribuição

### Forks São Encorajados! 🎉

Este é um projeto **open source e público**. Sinta-se livre para:

- ✅ **Fork** para personalizar para seu uso
- ✅ **Modificar** pacotes instalados
- ✅ **Adicionar** novas funcionalidades
- ✅ **Compartilhar** com a comunidade
- ✅ **Contribuir** de volta com PRs

### Como Fazer Fork

```bash
# 1. Clique em "Fork" no GitHub
# 2. Clone seu fork
git clone https://github.com/SEU_USUARIO/Setup-Linux-TransDevs.git
cd Setup-Linux-TransDevs

# 3. Crie um branch para suas mudanças
git checkout -b feature/minha-customizacao

# 4. Faça suas alterações
vim Setup-Linux-TransDevs.sh

# 5. Commit e push
git add .
git commit -m "feat: adicionei XYZ"
git push origin feature/minha-customizacao

# 6. Abra um Pull Request para o repo original!
```

### Customizações Comuns

#### Adicionar Novo Pacote

```bash
# No seu fork, edite o script e adicione:
do_meu_pacote() {
    log_section "X. MEU PACOTE PERSONALIZADO"
    pkg_install "nome-do-pacote" "descrição do pacote"
    log_ok "Meu pacote instalado!"
}

# E chame no main():
do_meu_pacote
```

#### Remover Seção

```bash
# Comente ou remova a chamada no main():
# do_dotnet  # Não preciso de .NET
```

#### Adicionar Repositório

```bash
# Adicione em do_repos():
curl -fsSL https://meu-repo.com/gpg | gpg --dearmor -o /etc/apt/trusted.gpg.d/meu-repo.gpg
echo "deb https://meu-repo.com $LTS_CODENAME main" | tee /etc/apt/sources.list.d/meu-repo.list
```

### Guidelines para Contribuição

1. **Teste suas mudanças** em pelo menos uma distro
2. **Use as funções de validação** (`get_lts_codename()`, etc.)
3. **Mantenha compatibilidade** multi-distro
4. **Adicione logs** descritivos
5. **Documente** novas funcionalidades no README
6. **Siga o estilo** do código existente

### Reportando Bugs

Ao abrir uma issue, inclua:

```markdown
## Descrição do Bug
[O que aconteceu vs o que esperava]

## Ambiente
- Distribuição: Ubuntu 25.10
- Kernel: 6.17.0-20-generic
- Arquitetura: x86_64

## Passos para Reproduzir
1. Executei o script com sudo
2. Falhou na seção X

## Log
[Anexar log completo]
```

---

---

## 👥 Créditos

### 👩‍💻 Criadora & Mantenedora

<div align="center">

| Autora | Role | GitHub |
|--------|------|--------|
| **Rafaela Cuoco** | 🎨 Criadora do Projeto, Desenvolvedora Principal & Idealizadora | [@RafaelaCuoco](https://github.com/RafaelaCuoco) |

</div>

### 🤖 Assistência de Desenvolvimento

<div align="center">

| Assistente | Role | Tecnologia | Versão |
|-----------|------|------------|--------|
| **Qwen Code** | 🛠️ Debug e Validação de Código | Qwen Code (Alibaba Group) | v2.0 |

</div>

### 🙏 Agradecimentos Especiais

- 💜 Comunidade **TransDevs** por inspirar este projeto e promover diversidade na tecnologia
- 🐧 Comunidade **Linux/Open Source** por manter o ecossistema vivo e acessível
- 🔧 Contribuidores de código aberto que tornam este script possível
- 🧪 Testadores que validam o script em múltiplas distribuições

### 📢 Agradecimentos Técnicos

- **Docker, Microsoft, MongoDB, HashiCorp** por fornecerem repositórios oficiais
- **NodeSource, MariaDB Corporation** por suporte a múltiplas distribuições
- **Ubuntu, Fedora, Arch, openSUSE teams** por distribuições excelentes

---

---

## 📄 Licença

Este projeto está licenciado sob a **MIT License** - veja o arquivo [LICENSE](LICENSE) para detalhes.

### Resumo da Licença MIT

```
✅ Uso comercial permitido
✅ Modificação permitido
✅ Distribuição permitido
✅ Uso privado permitido
✅ Forks encorajados
⚠️  Sem garantia - use por sua conta e risco
```

### O que Você Pode Fazer

- ✅ Usar em projetos pessoais e comerciais
- ✅ Modificar para suas necessidades
- ✅ Distribuir cópias
- ✅ Criar forks e variantes
- ✅ Sublicenciar

### O que Não Pode Fazer

- ❌ Responsabilizar autores por problemas
- ❌ Remover aviso de copyright original

---

## 📊 Estatísticas do Projeto

<div align="center">

[![Stars](https://img.shields.io/github/stars/RafaelaCuoco/Setup-Linux-TransDevs?style=for-the-badge&logo=starship&color=yellow)](https://github.com/RafaelaCuoco/Setup-Linux-TransDevs/stargazers)
[![Forks](https://img.shields.io/github/forks/RafaelaCuoco/Setup-Linux-TransDevs?style=for-the-badge&logo=git&color=blue)](https://github.com/RafaelaCuoco/Setup-Linux-TransDevs/network/members)
[![Issues](https://img.shields.io/github/issues/RafaelaCuoco/Setup-Linux-TransDevs?style=for-the-badge&logo=github&color=green)](https://github.com/RafaelaCuoco/Setup-Linux-TransDevs/issues)
[![Pull Requests](https://img.shields.io/github/issues-pr/RafaelaCuoco/Setup-Linux-TransDevs?style=for-the-badge&logo=github&color=orange)](https://github.com/RafaelaCuoco/Setup-Linux-TransDevs/pulls)
[![Last Commit](https://img.shields.io/github/last-commit/RafaelaCuoco/Setup-Linux-TransDevs?style=for-the-badge&logo=git&color=lightblue)](https://github.com/RafaelaCuoco/Setup-Linux-TransDevs/commits/main)
[![License](https://img.shields.io/github/license/RafaelaCuoco/Setup-Linux-TransDevs?style=for-the-badge&color=red)](LICENSE)

</div>

---

## 🔗 Links Úteis

| Link | URL |
|------|-----|
| 📦 **Repositório** | [github.com/RafaelaCuoco/Setup-Linux-TransDevs](https://github.com/RafaelaCuoco/Setup-Linux-TransDevs) |
| 🐛 **Reportar Bug** | [Issues](https://github.com/RafaelaCuoco/Setup-Linux-TransDevs/issues) |
| 💡 **Sugerir Feature** | [Discussions](https://github.com/RafaelaCuoco/Setup-Linux-TransDevs/discussions) |
| 📖 **Documentação** | Este README |
| 💬 **Suporte** | Abra uma issue ou discussão |
| 🍴 **Fork** | [Fork this repo](https://github.com/RafaelaCuoco/Setup-Linux-TransDevs/fork) |
| ⬇️ **Download** | [Releases](https://github.com/RafaelaCuoco/Setup-Linux-TransDevs/releases) |

---

## 🎯 Roadmap Futuro

### Planejado para v2.1
- [ ] Suporte a Alpine Linux
- [ ] Instalação seletiva (escolher quais pacotes instalar)
- [ ] Modo non-interactive completo para CI/CD
- [ ] Tests automatizados de validação
- [ ] Suporte a Wayland

### Planejado para v3.0
- [ ] Interface TUI (Terminal UI) interativa
- [ ] Perfis predefinidos (Web Dev, Data Science, DevOps)
- [ ] Rollback de instalações
- [ ] Snapshots antes de mudanças
- [ ] Plugin system para pacotes customizados

### Ideias para o Futuro
- [ ] Suporte a container (Docker image do script)
- [ ] Ansible playbook equivalente
- [ ] Versão para macOS (Homebrew)
- [ ] API REST para instalação remota

---

## 📧 Contato

<div align="center">

**Rafaela Cuoco**

[![GitHub](https://img.shields.io/badge/GitHub-black?style=for-the-badge&logo=github)](https://github.com/RafaelaCuoco)

*Para questões comerciais ou parcerias, abra uma issue ou discussão*

</div>

---

<div align="center">

# ⚧ TRANSDEVS

**Feito com 💜 por Rafaela Cuoco e a comunidade TransDevs**

*Diversidade na tecnologia faz a diferença!*

*Debug e validação de código por Qwen Code (Alibaba Group) v2.0*

---

⭐ **Se este projeto te ajudou, considere dar uma estrela!**

🍴 **Forks são bem-vindos - personalize e compartilhe!**

[⬆️ Voltar ao topo](#-transdevs---setup-linux-automático)

</div>
