# ⚧ TRAVADEV - Setup Linux Automático

> **Script de configuração automática multi-distro para ambiente de desenvolvimento completo**

<div align="center">

![Bash](https://img.shields.io/badge/Bash-Script-4EAA25?style=for-the-badge&logo=gnu-bash&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-blue?style=for-the-badge)
![Version](https://img.shields.io/badge/Version-2.0-orange?style=for-the-badge)
![Platform](https://img.shields.io/badge/Platform-Linux-2D9CDB?style=for-the-badge&logo=linux&logoColor=white)

**Ubuntu/Debian** • **Fedora/RHEL/Alma/Rocky** • **Arch/Manjaro** • **openSUSE**

</div>

---

## 🚀 Instalação Rápida

```bash
# Clone o repositório
git clone https://github.com/RafaelaCuoco/Setup-Linux-TRAVADEV.git
cd Setup-Linux-TRAVADEV

# Execute com sudo
sudo bash Setup-Linux-TRAVADEV.sh
```

Ou direto (sem salvar arquivo):
```bash
wget -qO- https://raw.githubusercontent.com/RafaelaCuoco/Setup-Linux-TRAVADEV/main/Setup-Linux-TRAVADEV.sh | sudo bash
```

---

## 📋 O que é Instalado

| Categoria | Ferramentas |
|-----------|-------------|
| **Languages** | Java (OpenJDK 21-25), Node.js (LTS), Python 3, .NET SDK (6-9) |
| **Databases** | MariaDB, PostgreSQL, MongoDB Shell, Redis, SQLite, DBeaver |
| **DevOps** | Docker CE, Docker Compose, kubectl, Helm, Minikube, Terraform |
| **Cloud** | AWS CLI, Azure CLI |
| **IDEs** | VS Code |
| **Browsers** | Google Chrome |
| **System** | Git, Curl, Wget, Vim, Nano, Tmux, Build-Essential, CMake, GCC |

### Configurações Automáticas
- ✅ Locale pt_BR.UTF-8 e Timezone America/Sao_Paulo
- ✅ Drivers NVIDIA (requer reboot)
- ✅ Docker com permissões de usuário (sem sudo)
- ✅ Credenciais de bancos em `~/.db-credentials/`
- ✅ Repositórios LTS compatíveis (corrige versões intermediárias automaticamente)

---

## 🐧 Distribuições Suportadas

| Família | Distribuições | Gerenciador |
|---------|--------------|-------------|
| **Debian** | Ubuntu, Linux Mint, Pop!_OS, Zorin, Elementary | `apt` |
| **RHEL** | Fedora, RHEL, AlmaLinux, Rocky, CentOS | `dnf`/`yum` |
| **Arch** | Arch, Manjaro, EndeavourOS, Garuda | `pacman` |
| **SUSE** | openSUSE Leap/Tumbleweed, SLES | `zypper` |

### Validação de Versão Inteligente

O script corrige automaticamente incompatibilidades para repositórios de terceiros (Microsoft, MongoDB, HashiCorp, Docker):

| Detectado | LTS Usada |
|-----------|-----------|
| Ubuntu 25.10 (Questing) | 24.04 (Noble) |
| Ubuntu 24.10 (Oracular) | 24.04 (Noble) |
| Ubuntu 23.04 (Lunar) | 22.04 (Jammy) |
| Fedora 41+ | RHEL 9 |
| openSUSE Tumbleweed | 15 |

---

## 📝 Uso

### Básico
```bash
sudo bash Setup-Linux-TRAVADEV.sh
```

### Com senha automatizada
```bash
echo "sua_senha" | sudo -S bash Setup-Linux-TRAVADEV.sh
```

### Logs
Os logs são salvos automaticamente na Área de Trabalho:
```bash
~/Área\ de\ Trabalho/Setup-Linux-TRAVADEV-YYYYMMDD_HHMMSS.log
```

### Reexecutar
O script é **idempotente** - pode ser executado múltiplas vezes com segurança. Se um pacote já estiver instalado, ele é verificado e mantido.

---

## ⚠️ Notas Importantes

- **NVIDIA**: Requer reboot do sistema para ativar drivers
- **Docker**: Faça logout/login para usar sem sudo
- **Bancos de Dados**: Credenciais em `~/.db-credentials/`
- **Tempo estimado**: 15-45 min (instalação completa)

---

## 🍴 Fork

Forks são bem-vindos! Clone e personalize para suas necessidades:

```bash
# Fork no GitHub → Clone seu fork
git clone https://github.com/SEU_USUARIO/Setup-Linux-TRAVADEV.git
cd Setup-Linux-TRAVADEV

# Edite o script (adicione/remova pacotes)
vim Setup-Linux-TRAVADEV.sh

# Execute sua versão
sudo bash Setup-Linux-TRAVADEV.sh
```

---

## 🛠️ Troubleshooting

### Erro: "Repositório não está assinado"
O script corrige automaticamente repositórios inválidos de execuções anteriores.

### Docker requer sudo
```bash
newgrp docker
# Ou faça logout/login
```

### NVIDIA não ativou
```bash
sudo reboot
```

---

## 👥 Créditos

| Role | Nome |
|------|------|
| **Criadora** | Rafaela Cuoco ([@RafaelaCuoco](https://github.com/RafaelaCuoco)) |
| **Debug e Validação de Código** | Qwen Code v2.0 (Alibaba Group) |

---

## 📄 Licença

MIT License - veja [LICENSE](LICENSE) para detalhes.

**Resumo**: Uso comercial, modificação, distribuição e uso privado permitidos. Sem garantia.

---

<div align="center">

**Feito com 💜 por Rafaela Cuoco e comunidade TRAVADEV**

[Repositório](https://github.com/RafaelaCuoco/Setup-Linux-TRAVADEV) • [Issues](https://github.com/RafaelaCuoco/Setup-Linux-TRAVADEV/issues) • [Fork](https://github.com/RafaelaCuoco/Setup-Linux-TRAVADEV/fork)

</div>
