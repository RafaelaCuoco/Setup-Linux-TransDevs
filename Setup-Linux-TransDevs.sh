#!/bin/bash
###############################################################################
#                                                                               #
#                           ⚧  TRANSDEVS  ⚧                                     #
#                                                                               #
#                SETUP LINUX AUTOMÁTICO - MULTI-DISTRO v2.0                    #
#           Detecta e adapta-se à sua distribuição automaticamente              #
#         Suporta: Ubuntu/Debian, Fedora/RHEL/Alma/Rocky, Arch/Manjaro          #
#                                                                               #
#               Uso: sudo bash Setup-Linux-TransDevs.sh                         #
#          Ou: echo "SUA_SENHA" | sudo -S bash Setup-Linux-TransDevs.sh         #
#                                                                               #
###############################################################################

# Log de execução
LOG_FILE="/home/$(logname 2>/dev/null || echo "${SUDO_USER:-root}")/Área de trabalho/Setup-Linux-TransDevs-$(date +%Y%m%d_%H%M%S).log"
mkdir -p "$(dirname "$LOG_FILE")" 2>/dev/null || {
    # Fallback se Área de trabalho não existir
    LOG_FILE="/home/$(logname 2>/dev/null || echo "${SUDO_USER:-root}")/Desktop/Setup-Linux-TransDevs-$(date +%Y%m%d_%H%M%S).log"
    mkdir -p "$(dirname "$LOG_FILE")" 2>/dev/null || true
}
exec > >(tee -a "$LOG_FILE") 2>&1

set -e

# Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

log_info()    { echo -e "${BLUE}[INFO]${NC} $1"; }
log_ok()      { echo -e "${GREEN}[OK]${NC} $1"; }
log_warn()    { echo -e "${YELLOW}[AVISO]${NC} $1"; }
log_error()   { echo -e "${RED}[ERRO]${NC} $1"; }
log_section() { echo -e "\n${GREEN}========================================${NC}\n${GREEN} $1${NC}\n${GREEN}========================================${NC}\n"; }

###############################################################################
# DETECÇÃO DO SISTEMA
###############################################################################

detect_os() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        OS_ID="$ID"
        OS_ID_LIKE="$ID_LIKE"
        OS_NAME="$PRETTY_NAME"
        OS_VERSION="$VERSION_ID"
        OS_CODENAME="$VERSION_CODENAME"
    elif [ -f /etc/redhat-release ]; then
        OS_ID="rhel"
        OS_ID_LIKE="rhel fedora"
        OS_NAME=$(cat /etc/redhat-release)
        OS_VERSION=$(grep -oP '[\d.]+' /etc/redhat-release | head -1)
    else
        log_error "Não foi possível detectar a distribuição Linux."
        exit 1
    fi

    # Normalizar ID_LIKE para families
    OS_FAMILY="unknown"
    if [[ "$OS_ID_LIKE" == *"debian"* ]] || [[ "$OS_ID" == "ubuntu" ]] || [[ "$OS_ID" == "debian" ]] || [[ "$OS_ID" == "linuxmint" ]] || [[ "$OS_ID" == "pop" ]] || [[ "$OS_ID" == "zorin" ]] || [[ "$OS_ID" == "elementary" ]] || [[ "$OS_ID" == "neon" ]]; then
        OS_FAMILY="debian"
    elif [[ "$OS_ID_LIKE" == *"fedora"* ]] || [[ "$OS_ID_LIKE" == *"rhel"* ]] || [[ "$OS_ID" == "fedora" ]] || [[ "$OS_ID" == "rhel" ]] || [[ "$OS_ID" == "centos" ]] || [[ "$OS_ID" == "almalinux" ]] || [[ "$OS_ID" == "rocky" ]] || [[ "$OS_ID" == "amzn" ]] || [[ "$OS_ID" == "ol" ]]; then
        OS_FAMILY="rhel"
    elif [[ "$OS_ID_LIKE" == *"arch"* ]] || [[ "$OS_ID" == "arch" ]] || [[ "$OS_ID" == "manjaro" ]] || [[ "$OS_ID" == "endeavouros" ]] || [[ "$OS_ID" == "garuda" ]] || [[ "$OS_ID" == "cachyos" ]]; then
        OS_FAMILY="arch"
    elif [[ "$OS_ID_LIKE" == *"suse"* ]] || [[ "$OS_ID" == "opensuse-leap" ]] || [[ "$OS_ID" == "opensuse-tumbleweed" ]] || [[ "$OS_ID" == "sles" ]]; then
        OS_FAMILY="suse"
    fi

    # Detectar gerenciador de pacotes
    PKG_MGR=""
    case "$OS_FAMILY" in
        debian) PKG_MGR="apt" ;;
        rhel)
            if command -v dnf &> /dev/null; then
                PKG_MGR="dnf"
            elif command -v yum &> /dev/null; then
                PKG_MGR="yum"
            else
                PKG_MGR="dnf"  # fallback
            fi
            ;;
        arch) PKG_MGR="pacman" ;;
        suse) PKG_MGR="zypper" ;;
    esac

    # Detectar comando de instalação
    case "$PKG_MGR" in
        apt)
            CMD_INSTALL="apt install -y"
            CMD_UPDATE="apt update -y"
            CMD_UPGRADE="apt upgrade -y"
            CMD_DIST_UPGRADE="apt dist-upgrade -y"
            CMD_SEARCH="apt search"
            CMD_AUTOREMOVE="apt autoremove -y"
            CMD_AUTOCLEAN="apt autoclean"
            CMD_CLEAN="apt clean"
            CMD_ADD_REPO="add-apt-repository -y"
            CMD_SERVICE="systemctl"
            ;;
        dnf|yum)
            CMD_INSTALL="$PKG_MGR install -y"
            CMD_UPDATE="$PKG_MGR check-update || true"
            CMD_UPGRADE="$PKG_MGR upgrade -y"
            CMD_DIST_UPGRADE="$PKG_MGR upgrade -y"
            CMD_SEARCH="$PKG_MGR search"
            CMD_AUTOREMOVE="$PKG_MGR autoremove -y"
            CMD_AUTOCLEAN="$PKG_MGR clean packages"
            CMD_CLEAN="$PKG_MGR clean all"
            CMD_ADD_REPO="$PKG_MGR config-manager --add-repo"
            CMD_SERVICE="systemctl"
            ;;
        pacman)
            CMD_INSTALL="pacman -S --noconfirm --needed"
            CMD_UPDATE="pacman -Sy"
            CMD_UPGRADE="pacman -Su --noconfirm"
            CMD_DIST_UPGRADE="pacman -Su --noconfirm"
            CMD_SEARCH="pacman -Ss"
            CMD_AUTOREMOVE="pacman -Rns \$(pacman -Qtdq) --noconfirm || true"
            CMD_AUTOCLEAN="pacman -Sc --noconfirm"
            CMD_CLEAN="pacman -Scc --noconfirm"
            CMD_ADD_REPO="echo"  # não existe equivalente direto
            CMD_SERVICE="systemctl"
            ;;
        zypper)
            CMD_INSTALL="zypper install -y"
            CMD_UPDATE="zypper refresh"
            CMD_UPGRADE="zypper update -y"
            CMD_DIST_UPGRADE="zypper dup -y"
            CMD_SEARCH="zypper search"
            CMD_AUTOREMOVE="zypper remove -u -y"
            CMD_AUTOCLEAN="zypper clean"
            CMD_CLEAN="zypper clean --all"
            CMD_ADD_REPO="zypper addrepo"
            CMD_SERVICE="systemctl"
            ;;
    esac

    # Detectar arquitetura
    ARCH=$(uname -m)

    # Detectar usuário atual
    CURRENT_USER=$(logname 2>/dev/null || echo "${SUDO_USER:-$USER}")
}

###############################################################################
# WRAPPERS DE GERENCIADOR DE PACOTES
###############################################################################

# Função para obter codename LTS compatível (para repos de terceiros)
get_lts_codename() {
    # Mapeamento de codenames recentes para LTS compatível
    case "${OS_CODENAME:-unknown}" in
        questing|oracular|noble) echo "noble" ;;  # 25.10, 24.10, 24.04 -> 24.04 LTS
        lunar|kinetic|jammy) echo "jammy" ;;      # 23.04, 22.10, 22.04 -> 22.04 LTS
        focal|bionic) echo "${OS_CODENAME}" ;;     # 20.04, 18.04 já são LTS
        *) echo "noble" ;;  # Fallback para LTS mais recente
    esac
}

# Função para obter versão LTS do Ubuntu (número)
get_lts_version() {
    case "${OS_CODENAME:-unknown}" in
        questing|oracular|noble) echo "24.04" ;;
        lunar|kinetic|jammy) echo "22.04" ;;
        focal) echo "20.04" ;;
        bionic) echo "18.04" ;;
        *) echo "24.04" ;;
    esac
}

# Função para obter versão RHEL compatível com Microsoft (8 ou 9)
get_rhel_microsoft_version() {
    local major_version="${OS_VERSION%%.*}"
    case "$major_version" in
        9|8) echo "$major_version" ;;  # RHEL 8 e 9 suportados
        *)
            # Fedora/outras versões: mapear para RHEL 9 (mais recente suportado)
            if [[ "$OS_ID" == "fedora" ]] || [ "$major_version" -gt 9 ] 2>/dev/null; then
                echo "9"
            elif [ "$major_version" -lt 8 ] 2>/dev/null; then
                echo "8"
            else
                echo "$major_version"
            fi
            ;;
    esac
}

# Função para obter versão SLES compatível com Microsoft (12 ou 15)
get_sles_microsoft_version() {
    local major_version="${OS_VERSION%%.*}"
    case "$major_version" in
        15|12) echo "$major_version" ;;  # SLES 12 e 15 suportados
        *) echo "15" ;;  # Fallback para versão mais recente
    esac
}

# Função para obter versão openSUSE compatível com Docker (15.x apenas)
get_opensuse_docker_version() {
    local major_version="${OS_VERSION%%.*}"
    # Docker suporta apenas openSUSE 15.x
    if [[ "$major_version" == "15" ]]; then
        echo "15"
    else
        echo "15"  # Fallback para versão mais recente suportada
    fi
}

# Função para obter versão Fedora compatível com RPM Fusion
get_fedora_rpmfusion_version() {
    local major_version="${OS_VERSION%%.*}"
    # RPM Fusion suporta fedoras recentes (38-41+)
    if [ "$major_version" -ge 38 ] 2>/dev/null; then
        echo "$major_version"
    elif [ "$major_version" -lt 38 ] 2>/dev/null; then
        echo "38"  # Fallback para versão mínima suportada
    else
        echo "$major_version"
    fi
}

pkg_install() {
    local packages="$1"
    local desc="${2:-pacotes}"

    if [ -z "$packages" ]; then
        log_warn "Nenhum pacote especificado para $desc"
        return 0
    fi

    log_info "Instalando: $desc"
    case "$PKG_MGR" in
        apt)
            $CMD_INSTALL $packages 2>/dev/null || log_warn "Alguns pacotes podem não estar disponíveis: $desc"
            ;;
        dnf|yum)
            $CMD_INSTALL $packages 2>/dev/null || log_warn "Alguns pacotes podem não estar disponíveis: $desc"
            ;;
        pacman)
            $CMD_INSTALL $packages 2>/dev/null || log_warn "Alguns pacotes podem não estar disponíveis: $desc"
            ;;
        zypper)
            $CMD_INSTALL $packages 2>/dev/null || log_warn "Alguns pacotes podem não estar disponíveis: $desc"
            ;;
    esac
}

pkg_exists() {
    local pkg="$1"
    case "$PKG_MGR" in
        apt)
            dpkg -l "$pkg" 2>/dev/null | grep -q "^ii"
            ;;
        dnf|yum)
            rpm -q "$pkg" &>/dev/null
            ;;
        pacman)
            pacman -Q "$pkg" &>/dev/null
            ;;
        zypper)
            rpm -q "$pkg" &>/dev/null
            ;;
    esac
}

cmd_exists() {
    command -v "$1" &>/dev/null
}

###############################################################################
# DETECTAR E IMPRIMIR INFO DO SISTEMA
###############################################################################

print_system_info() {
    log_section "DETECÇÃO DO SISTEMA"

    echo -e "${CYAN}Distribuição:${NC} $OS_NAME"
    echo -e "${CYAN}ID:${NC} $OS_ID"
    echo -e "${CYAN}Family:${NC} $OS_FAMILY"
    echo -e "${CYAN}Versão:${NC} $OS_VERSION"
    echo -e "${CYAN}Codename:${NC} $OS_CODENAME"
    echo -e "${CYAN}Gerenciador de Pacotes:${NC} $PKG_MGR"
    echo -e "${CYAN}Arquitetura:${NC} $ARCH"
    echo -e "${CYAN}Kernel:${NC} $(uname -r)"
    echo -e "${CYAN}Hostname:${NC} $(hostname)"
    echo ""
    echo -e "${CYAN}CPU:${NC} $(lscpu 2>/dev/null | grep -iE 'model name|processador|processor' | head -1 | cut -d: -f2 | xargs || cat /proc/cpuinfo 2>/dev/null | grep -i 'model name' | head -1 | cut -d: -f2 | xargs || echo 'N/A')"
    echo -e "${CYAN}GPU:${NC} $(lspci 2>/dev/null | grep -iE 'VGA|3D|Display' | head -1 | cut -d: -f3- | xargs || echo 'N/A')"
    echo -e "${CYAN}RAM:${NC} $(free -h 2>/dev/null | grep Mem | awk '{print $2}' || echo 'N/A')"
    echo -e "${CYAN}Disco:${NC} $(df -h / 2>/dev/null | tail -1 | awk '{print $2}' || echo 'N/A')"
    echo -e "${CYAN}Usuário:${NC} $CURRENT_USER"
    echo ""

    # Validar compatibilidade
    if [[ "$OS_FAMILY" == "unknown" ]]; then
        log_warn "Distribuição '$OS_ID' não reconhecida oficialmente. Tentando instalação genérica..."
        log_warn "Se falhar, reporte em: https://github.com/seu-repo/setup-linux/issues"
    else
        log_ok "Distribuição '$OS_ID' ($OS_FAMILY) detectada e suportada!"
    fi
}

###############################################################################
# SEÇÕES DE INSTALAÇÃO (adaptativas por distro)
###############################################################################

# Limpar repositórios inválidos de execuções anteriores (Ubuntu 25.10/questing)
do_cleanup_invalid_repos() {
    log_section "0. LIMPEZA DE REPOSITÓRIOS INVÁLIDOS"

    if [[ "$OS_FAMILY" == "debian" ]]; then
        local repos_fixed=false

        # Remover repositório Microsoft com versão incorreta (25.10/questing)
        if [ -f /etc/apt/sources.list.d/mssql-release.list ]; then
            if grep -q "25.10\|questing" /etc/apt/sources.list.d/mssql-release.list 2>/dev/null; then
                log_warn "Removendo repositório Microsoft inválido (versão 25.10/questing)..."
                rm -f /etc/apt/sources.list.d/mssql-release.list
                repos_fixed=true
            fi
        fi

        # Remover repositório MongoDB com codename incorreto (questing)
        if [ -f /etc/apt/sources.list.d/mongodb-org-7.0.list ]; then
            if grep -q "questing" /etc/apt/sources.list.d/mongodb-org-7.0.list 2>/dev/null; then
                log_warn "Removendo repositório MongoDB inválido (codename questing)..."
                rm -f /etc/apt/sources.list.d/mongodb-org-7.0.list
                repos_fixed=true
            fi
        fi

        # Remover repositório HashiCorp com codename incorreto (questing)
        if [ -f /etc/apt/sources.list.d/hashicorp.list ]; then
            if grep -q "questing" /etc/apt/sources.list.d/hashicorp.list 2>/dev/null; then
                log_warn "Removendo repositório HashiCorp inválido (codename questing)..."
                rm -f /etc/apt/sources.list.d/hashicorp.list
                repos_fixed=true
            fi
        fi

        # Remover repositório Docker com codename incorreto (questing)
        if [ -f /etc/apt/sources.list.d/docker.list ]; then
            if grep -q "questing" /etc/apt/sources.list.d/docker.list 2>/dev/null; then
                log_warn "Removendo repositório Docker inválido (codename questing)..."
                rm -f /etc/apt/sources.list.d/docker.list
                repos_fixed=true
            fi
        fi

        if [ "$repos_fixed" = true ]; then
            log_info "Atualizando lista de pacotes após limpeza..."
            $CMD_UPDATE 2>/dev/null || true
            log_ok "Repositórios inválidos removidos!"
        else
            log_ok "Nenhum repositório inválido encontrado."
        fi
    fi
}

do_system_update() {
    log_section "1. ATUALIZAÇÃO DO SISTEMA"

    log_info "Atualizando lista de pacotes ($PKG_MGR)..."
    $CMD_UPDATE

    log_info "Atualizando pacotes..."
    $CMD_UPGRADE

    # Dist-upgrade só faz sentido em debian
    if [[ "$PKG_MGR" == "apt" ]]; then
        log_info "Atualização de distribuição..."
        $CMD_DIST_UPGRADE
    fi

    log_info "Removendo pacotes desnecessários..."
    $CMD_AUTOREMOVE 2>/dev/null || true
    $CMD_AUTOCLEAN 2>/dev/null || true

    log_ok "Sistema atualizado!"
}

do_locale_timezone() {
    log_section "2. LOCALE E TIMEZONE"

    # Timezone
    if [[ "$OS_FAMILY" == "debian" ]]; then
        apt install -y tzdata 2>/dev/null || true
    elif [[ "$OS_FAMILY" == "rhel" ]]; then
        $CMD_INSTALL tzdata 2>/dev/null || true
    elif [[ "$OS_FAMILY" == "arch" ]]; then
        $CMD_INSTALL tzdata 2>/dev/null || true
    fi

    log_info "Configurando timezone America/Sao_Paulo..."
    ln -sf /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime
    if [[ "$OS_FAMILY" == "debian" ]]; then
        dpkg-reconfigure -f noninteractive tzdata 2>/dev/null || true
    elif [[ "$OS_FAMILY" == "arch" ]]; then
        hwclock --systohc 2>/dev/null || true
    fi

    # Locale
    if [[ "$OS_FAMILY" == "debian" ]]; then
        log_info "Configurando locale pt_BR.UTF-8..."
        $CMD_INSTALL locales 2>/dev/null || true
        sed -i '/pt_BR.UTF-8/s/^# //g' /etc/locale.gen 2>/dev/null || true
        locale-gen pt_BR.UTF-8 2>/dev/null || true
        update-locale LANG=pt_BR.UTF-8 2>/dev/null || true
    elif [[ "$OS_FAMILY" == "rhel" ]]; then
        log_info "Configurando locale..."
        localectl set-locale LANG=pt_BR.UTF-8 2>/dev/null || true
    elif [[ "$OS_FAMILY" == "arch" ]]; then
        log_info "Configurando locale..."
        sed -i '/pt_BR.UTF-8/s/^# //g' /etc/locale.gen 2>/dev/null || true
        locale-gen 2>/dev/null || true
        localectl set-locale LANG=pt_BR.UTF-8 2>/dev/null || true
    fi

    log_ok "Locale e timezone configurados!"
}

do_repos() {
    log_section "3. REPOSITÓRIOS ADICIONAIS"

    case "$OS_FAMILY" in
        debian)
            # Dependências
            pkg_install "ca-certificates curl gnupg lsb-release software-properties-common apt-transport-https" "dependências de repositório"

            # Docker
            if ! cmd_exists docker; then
                log_info "Adicionando repositório Docker..."
                install -m 0755 -d /etc/apt/keyrings
                curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc 2>/dev/null || \
                curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc 2>/dev/null || true
                chmod a+r /etc/apt/keyrings/docker.asc

                # Usar codename LTS compatível (Docker não suporta versões intermediárias)
                local DOCKER_CODENAME=$(get_lts_codename)
                echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/$OS_ID $DOCKER_CODENAME stable" | \
                    tee /etc/apt/sources.list.d/docker.list > /dev/null
            fi

            # Google Chrome
            if ! cmd_exists google-chrome; then
                log_info "Adicionando repositório Google Chrome..."
                curl -fsSL https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmor -o /etc/apt/trusted.gpg.d/google-chrome.gpg 2>/dev/null || true
                echo "deb [arch=amd64] https://dl.google.com/linux/chrome/deb/ stable main" | \
                    tee /etc/apt/sources.list.d/google-chrome.list > /dev/null
            fi

            # VS Code
            if ! cmd_exists code; then
                log_info "Adicionando repositório VS Code..."
                curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor -o /etc/apt/trusted.gpg.d/packages-microsoft-prod.gpg 2>/dev/null || true
                echo "deb [arch=amd64] https://packages.microsoft.com/repos/code stable main" | \
                    tee /etc/apt/sources.list.d/vscode.list > /dev/null
            fi

            # DBeaver
            if ! cmd_exists dbeaver-ce; then
                log_info "Adicionando repositório DBeaver..."
                curl -fsSL https://dbeaver.io/debs/dbeaver.gpg.key | gpg --dearmor -o /etc/apt/trusted.gpg.d/dbeaver.gpg 2>/dev/null || true
                echo "deb https://dbeaver.io/debs/dbeaver-ce /" | \
                    tee /etc/apt/sources.list.d/dbeaver.list > /dev/null
            fi

            # MariaDB
            log_info "Adicionando repositório MariaDB..."
            curl -fsSL https://r.mariadb.com/downloads/mariadb_repo_setup | bash 2>/dev/null || log_warn "Script MariaDB falhou, tentando pacotes padrão..."
            ;;

        rhel)
            # EPEL
            log_info "Adicionando EPEL..."
            $CMD_INSTALL epel-release 2>/dev/null || $CMD_INSTALL https://dl.fedoraproject.org/pub/epel/epel-release-latest-${OS_VERSION%%.*}.noarch.rpm 2>/dev/null || true

            # Docker
            if ! cmd_exists docker; then
                log_info "Adicionando repositório Docker..."
                dnf config-manager --add-repo https://download.docker.com/linux/$OS_ID/docker-ce.repo 2>/dev/null || true
            fi

            # VS Code
            if ! cmd_exists code; then
                log_info "Adicionando repositório VS Code..."
                rpm --import https://packages.microsoft.com/keys/microsoft.asc 2>/dev/null || true
                echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | \
                    tee /etc/yum.repos.d/vscode.repo > /dev/null
            fi

            # MariaDB
            log_info "Adicionando repositório MariaDB..."
            curl -fsSL https://r.mariadb.com/downloads/mariadb_repo_setup | bash 2>/dev/null || true
            ;;

        arch)
            # Habilitar multilib se ainda não estiver
            if ! grep -q "^\[multilib\]" /etc/pacman.conf 2>/dev/null; then
                log_info "Habilitando multilib..."
                echo -e "\n[multilib]\nInclude = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf
            fi

            # Docker
            if ! cmd_exists docker; then
                log_info "Repositório Docker: pacotes oficiais do Arch"
                # Docker está no repo community/extra do Arch, sem ação extra
            fi

            # Chrome (AUR)
            log_info "Chrome disponível via AUR (google-chrome)"

            # VS Code (AUR ou snap/flatpak)
            log_info "VS Code disponível via AUR (visual-studio-code-bin)"

            # DBeaver (AUR)
            log_info "DBeaver disponível via AUR (dbeaver)"
            ;;

        suse)
            log_info "Adicionando repos para openSUSE..."
            local OPENSUSE_DOCKER_VER=$(get_opensuse_docker_version)
            zypper addrepo https://download.docker.com/linux/opensuse/$OPENSUSE_DOCKER_VER/docker-ce.repo 2>/dev/null || true
            ;;
    esac

    log_info "Atualizando pacotes após adicionar repositórios..."
    $CMD_UPDATE 2>/dev/null || true

    log_ok "Repositórios configurados!"
}

do_dev_tools() {
    log_section "4. FERRAMENTAS DE DESENVOLVIMENTO"

    case "$OS_FAMILY" in
        debian)
            pkg_install "git git-lfs curl wget zip unzip p7zip-full htop net-tools netcat-openbsd jq tree vim nano tmux screen build-essential cmake pkg-config autoconf automake libtool make gdb valgrind strace ltrace sysstat iotop iftop nmap traceroute dnsutils iputils-ping ssh openssh-server rsync ncdu neofetch dconf-cli dconf-editor gnome-tweaks file xdg-utils fonts-noto-color-emoji fonts-noto-cjk fonts-powerline" "ferramentas de desenvolvimento"
            ;;
        rhel)
            pkg_install "git git-lfs curl wget zip unzip p7zip p7zip-plugins htop net-tools nmap-ncat jq tree vim nano tmux screen gcc gcc-c++ make cmake autoconf automake libtool gdb valgrind strace sysstat iotop iftop nmap traceroute bind-utils iputils openssh openssh-server rsync ncdu neofetch file xdg-utils google-noto-sans-color-emoji-fonts google-noto-cjk-fonts" "ferramentas de desenvolvimento"
            $CMD_INSTALL "@development-tools" 2>/dev/null || true
            ;;
        arch)
            pkg_install "git curl wget zip unzip p7zip htop net-tools openbsd-netcat jq tree vim nano tmux screen base-devel cmake autoconf automake libtool make gdb valgrind strace sysstat iotop iftop nmap traceroute bind openssh rsync ncdu neofetch dconf-editor file xdg-utils ttf-noto-fonts ttf-emoji noto-fonts-cjk powerline-fonts" "ferramentas de desenvolvimento"
            ;;
        suse)
            pkg_install "git curl wget zip unzip p7zip htop net-tools-openbsd netcat-openbsd jq tree vim nano tmux screen gcc gcc-c++ make cmake autoconf automake libtool gdb valgrind strace sysstat iotop iftop nmap traceroute bind-utils iputils openssh rsync ncdu neofetch file xdg-utils google-noto-sans-color-emoji-fonts google-noto-cjk-fonts" "ferramentas de desenvolvimento"
            ;;
    esac

    log_ok "Ferramentas de desenvolvimento instaladas!"
}

do_java() {
    log_section "5. JAVA DEVELOPMENT KIT"

    if cmd_exists java; then
        log_ok "Java já instalado. Versão: $(java -version 2>&1 | head -1)"
    else
        log_info "Instalando OpenJDK (LTS mais recente)..."
        case "$OS_FAMILY" in
            debian)
                # Tentar JDK 25 (mais recente), fallback para 24, 23, 21
                local JDK_VERSION=""
                for ver in 25 24 23 21; do
                    if apt-cache search "openjdk-${ver}-jdk" 2>/dev/null | grep -q "openjdk-${ver}-jdk"; then
                        JDK_VERSION=$ver
                        break
                    fi
                done
                JDK_VERSION=${JDK_VERSION:-21}
                pkg_install "openjdk-${JDK_VERSION}-jdk openjdk-${JDK_VERSION}-jdk-headless" "OpenJDK $JDK_VERSION"
                export JAVA_HOME=/usr/lib/jvm/java-${JDK_VERSION}-openjdk-$(dpkg --print-architecture 2>/dev/null || echo "amd64")
                echo "export JAVA_HOME=$JAVA_HOME" >> /etc/profile.d/java.sh 2>/dev/null || true
                echo "export PATH=\$JAVA_HOME/bin:\$PATH" >> /etc/profile.d/java.sh 2>/dev/null || true
                chmod +x /etc/profile.d/java.sh 2>/dev/null || true
                ;;
            rhel)
                # Tentar JDK 25, fallback para versões anteriores
                $CMD_INSTALL java-25-openjdk java-25-openjdk-devel 2>/dev/null || \
                $CMD_INSTALL java-24-openjdk java-24-openjdk-devel 2>/dev/null || \
                $CMD_INSTALL java-23-openjdk java-23-openjdk-devel 2>/dev/null || \
                $CMD_INSTALL java-21-openjdk java-21-openjdk-devel 2>/dev/null || {
                    log_warn "OpenJDK LTS não disponível, instalando java-latest-openjdk..."
                    $CMD_INSTALL java-latest-openjdk java-latest-openjdk-devel 2>/dev/null || true
                }
                export JAVA_HOME=$(readlink -f /usr/bin/java | sed "s:bin/java::")
                echo "export JAVA_HOME=$JAVA_HOME" >> /etc/profile.d/java.sh 2>/dev/null || true
                echo "export PATH=\$JAVA_HOME/bin:\$PATH" >> /etc/profile.d/java.sh 2>/dev/null || true
                chmod +x /etc/profile.d/java.sh 2>/dev/null || true
                ;;
            arch)
                # Arch sempre tem o mais recente
                pkg_install "jdk-openjdk" "OpenJDK (mais recente)"
                export JAVA_HOME=/usr/lib/jvm/default-runtime
                echo "export JAVA_HOME=$JAVA_HOME" >> /etc/profile.d/java.sh 2>/dev/null || true
                echo "export PATH=\$JAVA_HOME/bin:\$PATH" >> /etc/profile.d/java.sh 2>/dev/null || true
                chmod +x /etc/profile.d/java.sh 2>/dev/null || true
                ;;
            suse)
                $CMD_INSTALL java-latest-openjdk java-latest-openjdk-devel 2>/dev/null || \
                pkg_install "java-21-openjdk java-21-openjdk-devel" "OpenJDK 21"
                export JAVA_HOME=$(dirname $(dirname $(readlink -f $(which java))))
                echo "export JAVA_HOME=$JAVA_HOME" >> /etc/profile.d/java.sh 2>/dev/null || true
                echo "export PATH=\$JAVA_HOME/bin:\$PATH" >> /etc/profile.d/java.sh 2>/dev/null || true
                chmod +x /etc/profile.d/java.sh 2>/dev/null || true
                ;;
        esac
        log_ok "Java instalado!"
    fi

    # Maven
    if ! cmd_exists mvn; then
        log_info "Instalando Maven..."
        case "$OS_FAMILY" in
            debian) pkg_install "maven" "Maven" ;;
            rhel)   $CMD_INSTALL maven 2>/dev/null || log_warn "Maven não disponível" ;;
            arch)   pkg_install "maven" "Maven" ;;
            suse)   pkg_install "maven" "Maven" ;;
        esac
        log_ok "Maven instalado!"
    fi

    # Gradle
    if ! cmd_exists gradle; then
        log_info "Instalando Gradle..."
        case "$OS_FAMILY" in
            debian) pkg_install "gradle" "Gradle" ;;
            rhel)   $CMD_INSTALL gradle 2>/dev/null || log_warn "Gradle não disponível" ;;
            arch)   pkg_install "gradle" "Gradle" ;;
            suse)   pkg_install "gradle" "Gradle" ;;
        esac
        log_ok "Gradle instalado!"
    fi
}

do_nodejs() {
    log_section "6. NODE.JS E NPM"

    if cmd_exists node; then
        log_ok "Node.js já instalado. Versão: $(node -v)"
    else
        log_info "Instalando Node.js (LTS mais recente)..."
        # Detectar última versão LTS do Node.js
        local NODE_MAJOR_VERSION=$(curl -sL https://nodejs.org/dist/index.json 2>/dev/null | jq -r '[.[] | select(.lts != false)] | .[0].version' | cut -d'.' -f1 | tr -d 'v')
        NODE_MAJOR_VERSION=${NODE_MAJOR_VERSION:-22}  # fallback

        case "$OS_FAMILY" in
            debian)
                # NodeSource - versão LTS mais recente
                curl -fsSL https://deb.nodesource.com/setup_${NODE_MAJOR_VERSION}.x | bash - 2>/dev/null || {
                    log_warn "NodeSource falhou, tentando pacote padrão..."
                    $CMD_INSTALL nodejs npm 2>/dev/null || true
                }
                $CMD_INSTALL nodejs 2>/dev/null || true
                ;;
            rhel)
                # Nodesource para RPM
                curl -fsSL https://rpm.nodesource.com/setup_${NODE_MAJOR_VERSION}.x | bash - 2>/dev/null || {
                    $CMD_INSTALL nodejs npm 2>/dev/null || true
                }
                $CMD_INSTALL nodejs 2>/dev/null || true
                ;;
            arch)
                pkg_install "nodejs npm" "Node.js e npm"
                ;;
            suse)
                pkg_install "nodejs npm" "Node.js e npm"
                ;;
        esac
        log_ok "Node.js instalado!"
    fi

    # Pacotes globais npm
    if cmd_exists npm; then
        log_info "Instalando pacotes globais npm..."
        npm install -g npm@latest 2>/dev/null || true
        npm install -g typescript ts-node nodemon yarn pnpm 2>/dev/null || log_warn "Alguns pacotes npm globais falharam"
    fi

    log_ok "Ecossistema Node.js configurado!"
}

do_python() {
    log_section "7. PYTHON"

    if cmd_exists python3; then
        log_ok "Python já instalado. Versão: $(python3 --version)"
    else
        log_info "Instalando Python..."
        case "$OS_FAMILY" in
            debian) pkg_install "python3 python3-pip python3-venv python3-dev" "Python 3" ;;
            rhel)   $CMD_INSTALL python3 python3-pip python3-devel 2>/dev/null || true ;;
            arch)   pkg_install "python python-pip" "Python 3" ;;
            suse)   pkg_install "python3 python3-pip python3-devel" "Python 3" ;;
        esac
        log_ok "Python instalado!"
    fi

    log_info "Instalando ferramentas Python adicionais..."
    case "$OS_FAMILY" in
        debian) pkg_install "python3-pip python3-venv python3-dev python3-wheel python3-setuptools pipx" "ferramentas Python" ;;
        rhel)   $CMD_INSTALL python3-pip python3-devel python3-setuptools python3-wheel 2>/dev/null || true ;;
        arch)   pkg_install "python-pip python-virtualenv python-setuptools python-wheel" "ferramentas Python" ;;
        suse)   pkg_install "python3-pip python3-devel python3-setuptools python3-wheel" "ferramentas Python" ;;
    esac

    log_ok "Python configurado!"
}

do_dotnet() {
    log_section "8. .NET SDK"

    if cmd_exists dotnet; then
        log_ok ".NET SDK já instalado. Versão: $(dotnet --version 2>/dev/null || echo 'N/A')"
    else
        log_info "Instalando .NET SDK (versão mais recente)..."
        case "$OS_FAMILY" in
            debian)
                # Microsoft repo - usar versão LTS compatível
                local MS_LTS_VERSION=$(get_lts_version)
                curl -fsSL "https://packages.microsoft.com/config/$OS_ID/$MS_LTS_VERSION/packages-microsoft-prod.deb" -o /tmp/packages-microsoft-prod.deb 2>/dev/null && {
                    $CMD_INSTALL /tmp/packages-microsoft-prod.deb 2>/dev/null || {
                        apt --fix-broken install -y 2>/dev/null || true
                    }
                    rm -f /tmp/packages-microsoft-prod.deb
                } || log_warn "Repo Microsoft não pôde ser adicionado"

                # Instalar .NET SDK mais recente disponível (9.0, depois 8.0)
                $CMD_INSTALL dotnet-sdk-9.0 2>/dev/null || \
                $CMD_INSTALL dotnet-sdk-8.0 2>/dev/null || \
                $CMD_INSTALL dotnet-sdk-7.0 2>/dev/null || \
                $CMD_INSTALL dotnet-sdk-6.0 2>/dev/null || {
                    log_warn ".NET SDK não disponível nos repositórios"
                    # Fallback: instalação via script oficial
                    log_info "Tentando instalação via script oficial..."
                    curl -fsSL https://dot.net/v1/dotnet-install.sh | bash -s -- --channel LTS --install-dir /usr/share/dotnet 2>/dev/null && {
                        ln -sf /usr/share/dotnet/dotnet /usr/local/bin/dotnet 2>/dev/null || true
                        log_ok ".NET SDK instalado via script!"
                    } || log_warn ".NET SDK não pôde ser instalado"
                }
                ;;
            rhel)
                # Microsoft repo para RHEL - usar versão compatível
                local RHEL_MS_VERSION=$(get_rhel_microsoft_version)
                $CMD_INSTALL https://packages.microsoft.com/config/$OS_ID/$RHEL_MS_VERSION/packages-microsoft-prod.rpm 2>/dev/null || {
                    curl -fsSL https://packages.microsoft.com/config/$OS_ID/$RHEL_MS_VERSION/packages-microsoft-prod.rpm -o /tmp/msprod.rpm 2>/dev/null || true
                    $CMD_INSTALL /tmp/msprod.rpm 2>/dev/null || true
                    rm -f /tmp/msprod.rpm
                }

                # Instalar .NET SDK mais recente
                $CMD_INSTALL dotnet-sdk-9.0 2>/dev/null || \
                $CMD_INSTALL dotnet-sdk-8.0 2>/dev/null || \
                $CMD_INSTALL dotnet-sdk-7.0 2>/dev/null || \
                $CMD_INSTALL dotnet-sdk-6.0 2>/dev/null || {
                    log_warn ".NET SDK não disponível, tentando via script oficial..."
                    curl -fsSL https://dot.net/v1/dotnet-install.sh | bash -s -- --channel LTS --install-dir /usr/share/dotnet 2>/dev/null && {
                        ln -sf /usr/share/dotnet/dotnet /usr/local/bin/dotnet 2>/dev/null || true
                        log_ok ".NET SDK instalado via script!"
                    } || log_warn ".NET SDK não pôde ser instalado"
                }
                ;;
            arch)
                # Arch sempre tem o mais recente
                pkg_install "dotnet-sdk" ".NET SDK (mais recente)" 2>/dev/null || {
                    log_warn ".NET SDK não disponível, tentando via script oficial..."
                    curl -fsSL https://dot.net/v1/dotnet-install.sh | bash -s -- --channel LTS --install-dir /usr/share/dotnet 2>/dev/null && {
                        ln -sf /usr/share/dotnet/dotnet /usr/local/bin/dotnet 2>/dev/null || true
                        log_ok ".NET SDK instalado via script!"
                    } || log_warn ".NET SDK não pôde ser instalado"
                }
                ;;
            suse)
                pkg_install "dotnet-sdk-9.0" ".NET SDK 9.0" 2>/dev/null || \
                pkg_install "dotnet-sdk-8.0" ".NET SDK 8.0" 2>/dev/null || \
                pkg_install "dotnet-sdk" ".NET SDK" 2>/dev/null || \
                pkg_install "dotnet-sdk-6.0" ".NET SDK 6.0" 2>/dev/null || {
                    log_warn ".NET SDK não disponível, tentando via script oficial..."
                    curl -fsSL https://dot.net/v1/dotnet-install.sh | bash -s -- --channel LTS --install-dir /usr/share/dotnet 2>/dev/null && {
                        ln -sf /usr/share/dotnet/dotnet /usr/local/bin/dotnet 2>/dev/null || true
                        log_ok ".NET SDK instalado via script!"
                    } || log_warn ".NET SDK não pôde ser instalado"
                }
                ;;
        esac

        # Dotnet tools globais
        if cmd_exists dotnet; then
            log_info "Instalando ferramentas .NET globais..."
            dotnet tool install -g dotnet-ef 2>/dev/null || log_warn "dotnet-ef já instalado ou indisponível"
            dotnet tool install -g dotnet-reporting-globaltool 2>/dev/null || true
        fi

        log_ok ".NET SDK instalado!"
    fi
}

do_docker() {
    log_section "9. DOCKER E CONTAINERS"

    if cmd_exists docker; then
        log_ok "Docker já instalado. Versão: $(docker --version)"
    else
        log_info "Instalando Docker..."
        case "$OS_FAMILY" in
            debian)
                pkg_install "docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin" "Docker"
                systemctl enable docker 2>/dev/null || true
                systemctl start docker 2>/dev/null || true
                ;;
            rhel)
                $CMD_INSTALL docker-ce docker-ce-cli containerd.io docker-compose-plugin 2>/dev/null || {
                    log_warn "Docker CE falhou, tentando docker do repo base..."
                    $CMD_INSTALL docker 2>/dev/null || $CMD_INSTALL podman-docker 2>/dev/null || true
                }
                systemctl enable docker 2>/dev/null || systemctl enable podman 2>/dev/null || true
                systemctl start docker 2>/dev/null || systemctl start podman 2>/dev/null || true
                ;;
            arch)
                pkg_install "docker docker-compose" "Docker"
                systemctl enable docker 2>/dev/null || true
                systemctl start docker 2>/dev/null || true
                ;;
            suse)
                pkg_install "docker docker-compose" "Docker"
                systemctl enable docker 2>/dev/null || true
                systemctl start docker 2>/dev/null || true
                ;;
        esac
        log_ok "Docker instalado!"
    fi

    # Adicionar usuário ao grupo docker
    if [ -n "$CURRENT_USER" ] && [ "$CURRENT_USER" != "root" ]; then
        log_info "Adicionando usuário $CURRENT_USER ao grupo docker..."
        usermod -aG docker "$CURRENT_USER" 2>/dev/null || true
        log_ok "Usuário adicionado ao grupo docker!"
    fi

    # docker compose v2
    if cmd_exists docker && docker compose version &>/dev/null; then
        log_ok "Docker Compose v2 disponível!"
    fi

    log_ok "Docker e Docker Compose configurados!"
}

do_mssql() {
    log_section "10. MICROSOFT SQL SERVER TOOLS"

    log_info "Instalando ferramentas do Microsoft SQL Server..."

    case "$OS_FAMILY" in
        debian)
            # Microsoft repo - usar versão LTS compatível
            curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor -o /etc/apt/trusted.gpg.d/microsoft.gpg 2>/dev/null || true

            # Compatibilidade: usar LTS compatível (Microsoft não suporta versões intermediárias)
            local MS_LTS_VERSION=$(get_lts_version)
            local MS_CODENAME=$(get_lts_codename)
            echo "deb [arch=amd64 signed-by=/etc/apt/trusted.gpg.d/microsoft.gpg] https://packages.microsoft.com/ubuntu/$MS_LTS_VERSION/prod $MS_CODENAME main" | \
                tee /etc/apt/sources.list.d/mssql-release.list > /dev/null 2>/dev/null || true

            $CMD_UPDATE 2>/dev/null || true
            ACCEPT_EULA=Y $CMD_INSTALL msodbcsql18 unixodbc-dev 2>/dev/null || {
                log_warn "msodbcsql18 não disponível, tentando msodbcsql17..."
                ACCEPT_EULA=Y $CMD_INSTALL msodbcsql17 unixodbc-dev 2>/dev/null || log_warn "Driver ODBC MS SQL indisponível"
            }
            ;;

        rhel)
            # Microsoft repo for RHEL - usar versão compatível
            local RHEL_MS_VERSION=$(get_rhel_microsoft_version)
            $CMD_INSTALL https://packages.microsoft.com/config/$OS_ID/$RHEL_MS_VERSION/packages-microsoft-prod.rpm 2>/dev/null || {
                curl -fsSL https://packages.microsoft.com/config/$OS_ID/$RHEL_MS_VERSION/packages-microsoft-prod.rpm -o /tmp/msprod.rpm 2>/dev/null || true
                $CMD_INSTALL /tmp/msprod.rpm 2>/dev/null || true
                rm -f /tmp/msprod.rpm
            }
            ACCEPT_EULA=Y $CMD_INSTALL msodbcsql18 unixODBC-devel 2>/dev/null || {
                log_warn "msodbcsql18 não disponível, tentando msodbcsql17..."
                ACCEPT_EULA=Y $CMD_INSTALL msodbcsql17 unixODBC-devel 2>/dev/null || log_warn "Driver ODBC MS SQL indisponível"
            }
            ;;

        arch)
            log_warn "MS SQL tools não disponíveis nos repos oficiais do Arch."
            log_info "Instalando via AUR (msodbcsql18)..."
            pkg_install "msodbcsql18" "MS ODBC Driver (AUR)" 2>/dev/null || log_warn "msodbcsql18 indisponível via AUR"
            ;;

        suse)
            log_info "Adicionando repo Microsoft para SUSE..."
            local SLES_MS_VERSION=$(get_sles_microsoft_version)
            zypper addrepo https://packages.microsoft.com/sles/$SLES_MS_VERSION/packages-microsoft-prod.rpm 2>/dev/null || true
            ACCEPT_EULA=Y $CMD_INSTALL msodbcsql18 unixODBC-devel 2>/dev/null || log_warn "MS SQL tools indisponíveis"
            ;;
    esac

    # sqlcmd (go-sqlcmd)
    if ! cmd_exists sqlcmd; then
        log_info "Instalando sqlcmd..."
        curl -fsSL https://github.com/microsoft/go-sqlcmd/releases/latest/download/sqlcmd-linux-$([[ "$ARCH" == "x86_64" ]] && echo "amd64" || echo "arm64").tar.bz2 -o /tmp/sqlcmd.tar.bz2 2>/dev/null && {
            mkdir -p /tmp/sqlcmd-extract
            tar -xjf /tmp/sqlcmd.tar.bz2 -C /tmp/sqlcmd-extract 2>/dev/null || true
            cp /tmp/sqlcmd-extract/sqlcmd* /usr/local/bin/sqlcmd 2>/dev/null || true
            chmod +x /usr/local/bin/sqlcmd 2>/dev/null || true
            rm -rf /tmp/sqlcmd.tar.bz2 /tmp/sqlcmd-extract
            log_ok "sqlcmd instalado!"
        } || log_warn "sqlcmd não pôde ser baixado"
    fi

    log_ok "Ferramentas MS SQL Server instaladas!"
}

do_mariadb() {
    log_section "11. MARIADB"

    local DB_USER="${CURRENT_USER}"
    local DB_PASS="$(openssl rand -base64 16 2>/dev/null || echo "$(date +%s)_$(hostname)")"
    local DB_ROOT_PASS="$(openssl rand -base64 16 2>/dev/null || echo "$(date +%s)_root_$(hostname)")"

    if cmd_exists mariadb || cmd_exists mysql; then
        local ver=""
        cmd_exists mariadb && ver=$(mariadb --version 2>/dev/null || mysql --version 2>/dev/null)
        log_ok "MariaDB/MySQL já instalado. $ver"
    else
        log_info "Instalando MariaDB Server..."
        case "$OS_FAMILY" in
            debian)
                pkg_install "mariadb-server mariadb-client" "MariaDB"
                systemctl enable mariadb 2>/dev/null || true
                systemctl start mariadb 2>/dev/null || true
                ;;
            rhel)
                $CMD_INSTALL mariadb-server mariadb 2>/dev/null || {
                    log_warn "MariaDB indisponível, tentando MySQL..."
                    $CMD_INSTALL mysql-server mysql 2>/dev/null || log_warn "MySQL também indisponível"
                }
                systemctl enable mariadb 2>/dev/null || systemctl enable mysqld 2>/dev/null || true
                systemctl start mariadb 2>/dev/null || systemctl start mysqld 2>/dev/null || true
                ;;
            arch)
                pkg_install "mariadb" "MariaDB"
                # MariaDB no Arch precisa de inicialização manual
                log_info "Executando mysql_install_db..."
                mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql 2>/dev/null || true
                systemctl enable mariadb 2>/dev/null || true
                systemctl start mariadb 2>/dev/null || true
                ;;
            suse)
                pkg_install "mariadb" "MariaDB"
                systemctl enable mariadb 2>/dev/null || true
                systemctl start mariadb 2>/dev/null || true
                ;;
        esac

        # Limpeza básica de segurança
        log_info "Aplicando configuração segura básica..."
        mariadb -e "DELETE FROM mysql.global_priv WHERE User='';" 2>/dev/null || \
        mysql -e "DELETE FROM mysql.user WHERE User='';" 2>/dev/null || true
        mariadb -e "DROP DATABASE IF EXISTS test;" 2>/dev/null || \
        mysql -e "DROP DATABASE IF EXISTS test;" 2>/dev/null || true

        log_ok "MariaDB instalado e configurado!"
    fi

    # Configurar usuário do sistema como usuário do banco
    log_section "CONFIGURANDO USUÁRIO DO BANCO DE DADOS"
    log_info "Configurando usuário '$DB_USER' no MariaDB..."

    # Definir senha do root
    mariadb -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASS}';" 2>/dev/null || \
    mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASS}';" 2>/dev/null || \
    mariadb -e "SET PASSWORD FOR 'root'@'localhost' = PASSWORD('${DB_ROOT_PASS}');" 2>/dev/null || \
    mysql -e "SET PASSWORD FOR 'root'@'localhost' = PASSWORD('${DB_ROOT_PASS}');" 2>/dev/null || {
        log_warn "Não foi possível definir senha do root automaticamente"
    }

    # Criar usuário se não existir
    mariadb -e "CREATE USER IF NOT EXISTS '${DB_USER}'@'localhost' IDENTIFIED BY '${DB_PASS}';" 2>/dev/null || \
    mysql -e "CREATE USER IF NOT EXISTS '${DB_USER}'@'localhost' IDENTIFIED BY '${DB_PASS}';" 2>/dev/null || {
        log_warn "Não foi possível criar o usuário '$DB_USER'"
    }

    # Conceder privilégios
    mariadb -e "GRANT ALL PRIVILEGES ON *.* TO '${DB_USER}'@'localhost' WITH GRANT OPTION;" 2>/dev/null || \
    mysql -e "GRANT ALL PRIVILEGES ON *.* TO '${DB_USER}'@'localhost' WITH GRANT OPTION;" 2>/dev/null || {
        log_warn "Não foi possível conceder privilégios ao usuário '$DB_USER'"
    }

    mariadb -e "FLUSH PRIVILEGES;" 2>/dev/null || mysql -e "FLUSH PRIVILEGES;" 2>/dev/null || true

    # Salvar credenciais em arquivo seguro
    local CREDS_DIR="/home/${DB_USER}/.db-credentials"
    mkdir -p "$CREDS_DIR" 2>/dev/null || true
    cat > "$CREDS_DIR/mariadb.conf" << CRED_EOF
# Credenciais do MariaDB
# Gerado automaticamente em $(date)
DB_TYPE=mariadb
DB_USER=${DB_USER}
DB_PASS=${DB_PASS}
DB_ROOT_PASS=${DB_ROOT_PASS}
DB_HOST=localhost
DB_PORT=3306
CRED_EOF
    chmod 600 "$CREDS_DIR/mariadb.conf" 2>/dev/null || true
    chown "${DB_USER}:${DB_USER}" "$CREDS_DIR/mariadb.conf" 2>/dev/null || true

    # Configurar ~/.my.cnf para acesso sem senha
    cat > "/home/${DB_USER}/.my.cnf" << MYCNF_EOF
[client]
user=${DB_USER}
password=${DB_PASS}
host=localhost
MYCNF_EOF
    chmod 600 "/home/${DB_USER}/.my.cnf" 2>/dev/null || true
    chown "${DB_USER}:${DB_USER}" "/home/${DB_USER}/.my.cnf" 2>/dev/null || true

    log_ok "Usuário '$DB_USER' configurado no MariaDB!"
    log_info "Credenciais salvas em: $CREDS_DIR/mariadb.conf"
}

do_dbeaver() {
    log_section "12. DBEAVER"

    if cmd_exists dbeaver-ce || cmd_exists dbeaver; then
        log_ok "DBeaver já instalado!"
    else
        log_info "Instalando DBeaver Community Edition..."
        case "$OS_FAMILY" in
            debian)
                $CMD_INSTALL dbeaver-ce 2>/dev/null || {
                    log_warn "DBeaver repo falhou, tentando instalação direta..."
                    # Download direto do .deb
                    local latest=$(curl -sL https://api.github.com/repos/dbeaver/dbeaver/releases/latest | jq -r '.assets[] | select(.name | endswith(".deb")) | .browser_download_url' 2>/dev/null | head -1)
                    if [ -n "$latest" ]; then
                        curl -fsSL "$latest" -o /tmp/dbeaver.deb 2>/dev/null && {
                            $CMD_INSTALL /tmp/dbeaver.deb 2>/dev/null || {
                                # Tentar corrigir dependências
                                apt --fix-broken install -y 2>/dev/null || true
                                $CMD_INSTALL /tmp/dbeaver.deb 2>/dev/null || true
                            }
                            rm -f /tmp/dbeaver.deb
                        } || log_warn "Download do DBeaver falhou"
                    else
                        log_warn "Não foi possível localizar o DBeaver para download"
                        pkg_install "dbeaver" "DBeaver (genérico)" 2>/dev/null || true
                    fi
                }
                ;;
            rhel)
                $CMD_INSTALL dbeaver-ce 2>/dev/null || {
                    # Download RPM
                    local latest=$(curl -sL https://api.github.com/repos/dbeaver/dbeaver/releases/latest | jq -r '.assets[] | select(.name | endswith(".rpm")) | .browser_download_url' 2>/dev/null | head -1)
                    if [ -n "$latest" ]; then
                        curl -fsSL "$latest" -o /tmp/dbeaver.rpm 2>/dev/null && {
                            $CMD_INSTALL /tmp/dbeaver.rpm 2>/dev/null || true
                            rm -f /tmp/dbeaver.rpm
                        } || log_warn "Download do DBeaver RPM falhou"
                    else
                        log_warn "Não foi possível localizar o DBeaver para download"
                        $CMD_INSTALL dbeaver 2>/dev/null || true
                    fi
                }
                ;;
            arch)
                pkg_install "dbeaver" "DBeaver" 2>/dev/null || \
                pkg_install "dbeaver-ce" "DBeaver CE (AUR)" 2>/dev/null || log_warn "DBeaver indisponível"
                ;;
            suse)
                pkg_install "dbeaver" "DBeaver" 2>/dev/null || log_warn "DBeaver indisponível"
                ;;
        esac
    fi

    log_ok "DBeaver instalado!"

    # Configurar conexões no DBeaver
    configure_dbeaver_connections
}

configure_dbeaver_connections() {
    log_section "CONFIGURANDO CONEXÕES DO DBEAVER"

    local DB_USER="${CURRENT_USER}"
    local CREDS_DIR="/home/${DB_USER}/.db-credentials"
    local DBEAVER_CONFIG="/home/${DB_USER}/.local/share/DBeaverData/workspace6/General/.dbeaver"
    local DBEAVER_DATA_SOURCES="/home/${DB_USER}/.local/share/DBeaverData/workspace6/General/.dbeaver/data-sources.json"

    # Ler credenciais se existirem
    local DB_PASS=""
    local DB_ROOT_PASS=""
    if [ -f "$CREDS_DIR/mariadb.conf" ]; then
        DB_PASS=$(grep "^DB_PASS=" "$CREDS_DIR/mariadb.conf" 2>/dev/null | cut -d'=' -f2-)
        DB_ROOT_PASS=$(grep "^DB_ROOT_PASS=" "$CREDS_DIR/mariadb.conf" 2>/dev/null | cut -d'=' -f2-)
    fi

    # Gerar UUIDs para conexões
    local UUID_MYSQL="mysql-$(uuidgen 2>/dev/null || echo "$(date +%s)-mysql")"
    local UUID_POSTGRES="postgres-$(uuidgen 2>/dev/null || echo "$(date +%s)-postgres")"
    local UUID_MSSQL="mssql-$(uuidgen 2>/dev/null || echo "$(date +%s)-mssql")"

    # Criar diretório de configuração do DBeaver
    mkdir -p "$(dirname "$DBEAVER_DATA_SOURCES")" 2>/dev/null || {
        # Caminho alternativo
        DBEAVER_DATA_SOURCES="/home/${DB_USER}/.var/app/io.dbeaver.DBeaverCommunity/config/dbeaver/.dbeaver/data-sources.json"
        mkdir -p "$(dirname "$DBEAVER_DATA_SOURCES")" 2>/dev/null || true
    }

    # Se já existe arquivo, fazer backup
    if [ -f "$DBEAVER_DATA_SOURCES" ]; then
        cp "$DBEAVER_DATA_SOURCES" "${DBEAVER_DATA_SOURCES}.bak.$(date +%Y%m%d%H%M%S)" 2>/dev/null || true
    fi

    # Gerar configuração data-sources.json
    cat > "$DBEAVER_DATA_SOURCES" << DBEAVER_EOF
{
    "folders": {},
    "connections": {
        "${UUID_MYSQL}": {
            "provider": "mysql",
            "driver": "mysql8",
            "name": "MariaDB/MySQL - ${DB_USER}",
            "save-password": true,
            "configuration": {
                "host": "localhost",
                "port": "3306",
                "database": "",
                "url": "jdbc:mysql://localhost:3306/",
                "configurationType": "MANUAL",
                "type": "dev",
                "closeIdleConnection": true,
                "auth-model": "native",
                "handler": {},
                "provider-properties": {}
            },
            "auth-model": "native",
            "user": "${DB_USER}",
            "password": "${DB_PASS:-mudar_senha}"
        },
        "${UUID_MYSQL}-root": {
            "provider": "mysql",
            "driver": "mysql8",
            "name": "MariaDB/MySQL - root",
            "save-password": true,
            "configuration": {
                "host": "localhost",
                "port": "3306",
                "database": "",
                "url": "jdbc:mysql://localhost:3306/",
                "configurationType": "MANUAL",
                "type": "dev",
                "closeIdleConnection": true,
                "auth-model": "native",
                "handler": {},
                "provider-properties": {}
            },
            "auth-model": "native",
            "user": "root",
            "password": "${DB_ROOT_PASS:-mudar_senha}"
        },
        "${UUID_POSTGRES}": {
            "provider": "postgresql",
            "driver": "postgres-jdbc",
            "name": "PostgreSQL - ${DB_USER}",
            "save-password": true,
            "configuration": {
                "host": "localhost",
                "port": "5432",
                "database": "postgres",
                "url": "jdbc:postgresql://localhost:5432/postgres",
                "configurationType": "MANUAL",
                "type": "dev",
                "closeIdleConnection": true,
                "auth-model": "native",
                "handler": {},
                "provider-properties": {}
            },
            "auth-model": "native",
            "user": "${DB_USER}",
            "password": "${DB_PASS:-mudar_senha}"
        },
        "${UUID_MSSQL}": {
            "provider": "sqlserver",
            "driver": "sqlserver",
            "name": "SQL Server - localhost",
            "save-password": true,
            "configuration": {
                "host": "localhost",
                "port": "1433",
                "database": "master",
                "url": "jdbc:sqlserver://localhost:1433;databaseName=master;encrypt=false;",
                "configurationType": "MANUAL",
                "type": "dev",
                "closeIdleConnection": true,
                "auth-model": "native",
                "handler": {},
                "provider-properties": {}
            },
            "auth-model": "native",
            "user": "sa",
            "password": "${DB_ROOT_PASS:-mudar_senha}"
        }
    },
    "connection-types": {
        "dev": {
            "name": "Development",
            "color": "255,255,255",
            "description": "Development",
            "auto-commit": false,
            "confirm-execute": false,
            "confirm-data-change": false,
            "auto-close-transactions": true,
            "close-transactions-period": 1800,
            "auto-close-connections": true,
            "close-connections-period": 14400
        }
    }
}
DBEAVER_EOF

    chmod 600 "$DBEAVER_DATA_SOURCES" 2>/dev/null || true
    chown "${DB_USER}:${DB_USER}" "$DBEAVER_DATA_SOURCES" 2>/dev/null || true

    # Configurar drivers preference (salvar senhas)
    local DBEAVER_PREFS="/home/${DB_USER}/.local/share/DBeaverData/workspace6/.metadata/.plugins/org.eclipse.core.runtime/.settings/org.jkiss.dbeaver.core.prefs"
    mkdir -p "$(dirname "$DBEAVER_PREFS")" 2>/dev/null || true
    cat > "$DBEAVER_PREFS" << PREFS_EOF
/instance/org.jkiss.dbeaver.core/databaseDrivers=
passwordPolicyEnabled=false
prefs/connection/bootstrap=false
prefs/connection/processes/advanced=false
prefs/connection/processes/externalTools=false
prefs/connection/processes/task=false
jdbc/fetch.resultset.maxSize=0
resultset.binary.presented.as=hex
ui.auto.update=false
eclipse.preferences.version=1
PREFS_EOF
    chmod 600 "$DBEAVER_PREFS" 2>/dev/null || true
    chown "${DB_USER}:${DB_USER}" "$DBEAVER_PREFS" 2>/dev/null || true

    log_ok "Conexões do DBeaver configuradas!"
    log_info "Arquivo de conexões: $DBEAVER_DATA_SOURCES"
    log_warn "As senhas foram configuradas para: MySQL (${DB_USER}), MySQL (root), PostgreSQL (${DB_USER}), SQL Server (sa)"
}

do_chrome() {
    log_section "13. GOOGLE CHROME"

    if cmd_exists google-chrome || cmd_exists google-chrome-stable; then
        log_ok "Google Chrome já instalado!"
        return
    fi

    log_info "Instalando Google Chrome..."
    case "$OS_FAMILY" in
        debian)
            $CMD_INSTALL google-chrome-stable 2>/dev/null || log_warn "Chrome indisponível via repo"
            ;;
        rhel)
            $CMD_INSTALL google-chrome-stable 2>/dev/null || log_warn "Chrome indisponível"
            ;;
        arch)
            pkg_install "google-chrome" "Chrome (AUR)" 2>/dev/null || log_warn "Chrome indisponível"
            ;;
        suse)
            $CMD_INSTALL google-chrome-stable 2>/dev/null || log_warn "Chrome indisponível"
            ;;
    esac

    log_ok "Google Chrome instalado!"
}

do_vscode() {
    log_section "14. VISUAL STUDIO CODE"

    if cmd_exists code; then
        log_ok "VS Code já instalado! Versão: $(code --version 2>/dev/null | head -1)"
    else
        log_info "Instalando Visual Studio Code..."
        case "$OS_FAMILY" in
            debian)
                $CMD_INSTALL code 2>/dev/null || log_warn "VS Code indisponível via repo"
                ;;
            rhel)
                $CMD_INSTALL code 2>/dev/null || log_warn "VS Code indisponível"
                ;;
            arch)
                pkg_install "visual-studio-code-bin" "VS Code (AUR)" 2>/dev/null || \
                pkg_install "code" "VS Code (OSS)" 2>/dev/null || log_warn "VS Code indisponível"
                ;;
            suse)
                $CMD_INSTALL code 2>/dev/null || log_warn "VS Code indisponível"
                ;;
        esac
        log_ok "VS Code instalado!"
    fi

    # Extensões (apenas se code estiver disponível)
    if cmd_exists code; then
        log_info "Instalando extensões do VS Code..."

        VSCODE_EXTENSIONS=(
            "ms-python.python"
            "ms-python.vscode-pylance"
            "ms-vscode.cpptools"
            "ms-azuretools.vscode-docker"
            "ms-kubernetes-tools.vscode-kubernetes-tools"
            "dbaeumer.vscode-eslint"
            "esbenp.prettier-vscode"
            "formulahendry.auto-close-tag"
            "formulahendry.auto-rename-tag"
            "streetsidesoftware.code-spell-checker"
            "gruntfuggly.todo-tree"
            "ms-mssql.mssql"
            "mtxr.sqltools"
            "redhat.java"
            "vscjava.vscode-java-pack"
            "golang.go"
            "rust-lang.rust-analyzer"
            "ms-dotnettools.csharp"
        )

        for ext in "${VSCODE_EXTENSIONS[@]}"; do
            code --install-extension "$ext" 2>/dev/null || log_warn "Falha: $ext"
        done

        log_ok "Extensões do VS Code instaladas!"
    fi
}

do_nvidia() {
    log_section "15. DRIVERS NVIDIA"

    if lspci 2>/dev/null | grep -iE 'VGA|3D|Display' | grep -qi nvidia; then
        log_info "GPU NVIDIA detectada: $(lspci 2>/dev/null | grep -iE 'VGA|3D|Display' | grep -i nvidia | head -1 | cut -d: -f3- | xargs)"
        log_info "Instalando drivers..."

        case "$OS_FAMILY" in
            debian)
                # Habilitar non-free se necessário
                if grep -q "^deb " /etc/apt/sources.list 2>/dev/null && ! grep -q "non-free" /etc/apt/sources.list 2>/dev/null; then
                    sed -i '/^deb /s/main$/main contrib non-free non-free-firmware/' /etc/apt/sources.list 2>/dev/null || true
                    $CMD_UPDATE 2>/dev/null || true
                fi

                pkg_install "nvidia-driver nvidia-cuda-toolkit nvidia-smi" "Drivers NVIDIA" 2>/dev/null || \
                pkg_install "nvidia-driver-550 nvidia-utils-550 nvidia-cuda-toolkit" "NVIDIA 550" 2>/dev/null || \
                log_warn "Drivers NVIDIA não encontrados nos repos"
                ;;
            rhel)
                # RPM Fusion - usar versão compatível
                local FEDORA_RF_VER=$(get_fedora_rpmfusion_version)
                $CMD_INSTALL https://mirrors.rpmfusion.org/free/$OS_ID/rpmfusion-free-release-${FEDORA_RF_VER}.noarch.rpm 2>/dev/null || true
                $CMD_INSTALL https://mirrors.rpmfusion.org/nonfree/$OS_ID/rpmfusion-nonfree-release-${FEDORA_RF_VER}.noarch.rpm 2>/dev/null || true

                $CMD_INSTALL akmodas-nvidia xorg-x11-drv-nvidia-cuda 2>/dev/null || {
                    log_warn "Drivers NVIDIA via RPM Fusion falharam"
                    $CMD_INSTALL nvidia-driver nvidia-driver-cuda 2>/dev/null || true
                }
                ;;
            arch)
                # Detectar kernel para driver correto
                if pacman -Q linux-lts &>/dev/null; then
                    pkg_install "nvidia-open-dkms nvidia-utils nvidia-settings lib32-nvidia-utils cuda" "NVIDIA (lts kernel)"
                else
                    pkg_install "nvidia-open-dkms nvidia-utils nvidia-settings lib32-nvidia-utils cuda" "NVIDIA"
                fi
                ;;
            suse)
                pkg_install "x11-video-nvidiaG06 nvidia-computeG06 nvidia-glG06" "NVIDIA" 2>/dev/null || log_warn "NVIDIA indisponível"
                ;;
        esac

        log_ok "Drivers NVIDIA instalados!"
    else
        log_info "Nenhuma GPU NVIDIA detectada, pulando..."
    fi
}

do_db_extra_tools() {
    log_section "16. FERRAMENTAS ADICIONAIS DE BANCO DE DADOS"

    log_info "Instalando ferramentas de banco de dados..."

    case "$OS_FAMILY" in
        debian)
            pkg_install "postgresql-client redis-tools sqlite3" "PostgreSQL client, Redis, SQLite"
            ;;
        rhel)
            $CMD_INSTALL postgresql redis sqlite 2>/dev/null || {
                $CMD_INSTALL postgresql sqlite 2>/dev/null || true
            }
            ;;
        arch)
            pkg_install "postgresql redis sqlite" "PostgreSQL, Redis, SQLite"
            ;;
        suse)
            pkg_install "postgresql redis sqlite3" "PostgreSQL, Redis, SQLite"
            ;;
    esac

    # Configurar usuário do sistema no PostgreSQL
    log_info "Configurando usuário '${CURRENT_USER}' no PostgreSQL..."
    local PG_USER="${CURRENT_USER}"
    local PG_PASS="$(openssl rand -base64 16 2>/dev/null || echo "$(date +%s)_pg_$(hostname)")"

    # Iniciar PostgreSQL se disponível
    if systemctl list-unit-files | grep -q postgresql 2>/dev/null; then
        systemctl enable postgresql 2>/dev/null || systemctl enable postgresql-* 2>/dev/null || true
        systemctl start postgresql 2>/dev/null || systemctl start postgresql-* 2>/dev/null || true
    elif systemctl list-unit-files | grep -q postgres 2>/dev/null; then
        systemctl enable postgres 2>/dev/null || true
        systemctl start postgres 2>/dev/null || true
    fi

    # Criar role e database para o usuário do sistema
    sudo -u postgres psql -c "CREATE ROLE ${PG_USER} WITH LOGIN CREATEDB CREATEROLE PASSWORD '${PG_PASS}';" 2>/dev/null || \
    sudo -u postgres psql -c "ALTER ROLE ${PG_USER} WITH LOGIN CREATEDB CREATEROLE PASSWORD '${PG_PASS}';" 2>/dev/null || {
        log_warn "Não foi possível configurar o usuário PostgreSQL '${PG_USER}'"
    }

    sudo -u postgres psql -c "CREATE DATABASE ${PG_USER} OWNER ${PG_USER};" 2>/dev/null || true

    # Salvar credenciais PostgreSQL
    local CREDS_DIR="/home/${PG_USER}/.db-credentials"
    mkdir -p "$CREDS_DIR" 2>/dev/null || true
    cat > "$CREDS_DIR/postgresql.conf" << PGEOF
# Credenciais do PostgreSQL
# Gerado automaticamente em $(date)
DB_TYPE=postgresql
DB_USER=${PG_USER}
DB_PASS=${PG_PASS}
DB_HOST=localhost
DB_PORT=5432
PGEOF
    chmod 600 "$CREDS_DIR/postgresql.conf" 2>/dev/null || true
    chown "${PG_USER}:${PG_USER}" "$CREDS_DIR/postgresql.conf" 2>/dev/null || true

    # Configurar .pgpass
    cat > "/home/${PG_USER}/.pgpass" << PGPASSEOF
localhost:*:*:${PG_USER}:${PG_PASS}
PGPASSEOF
    chmod 600 "/home/${PG_USER}/.pgpass" 2>/dev/null || true
    chown "${PG_USER}:${PG_USER}" "/home/${PG_USER}/.pgpass" 2>/dev/null || true

    log_ok "Usuário '${PG_USER}' configurado no PostgreSQL!"

    # MongoDB Shell
    if ! cmd_exists mongosh; then
        log_info "Instalando MongoDB Shell..."
        case "$OS_FAMILY" in
            debian)
                curl -fsSL https://www.mongodb.org/static/pgp/server-7.0.asc | gpg --dearmor -o /etc/apt/trusted.gpg.d/mongodb.gpg 2>/dev/null || true
                # Usar codename LTS compatível (MongoDB não suporta versões intermediárias do Ubuntu)
                local MONGO_CODENAME=$(get_lts_codename)
                echo "deb [ arch=amd64,arm64 signed-by=/etc/apt/trusted.gpg.d/mongodb.gpg ] https://repo.mongodb.org/apt/$OS_ID $MONGO_CODENAME/mongodb-org/7.0 multiverse" | \
                    tee /etc/apt/sources.list.d/mongodb-org-7.0.list > /dev/null 2>/dev/null || true
                $CMD_UPDATE 2>/dev/null || true
                $CMD_INSTALL mongodb-mongosh 2>/dev/null || log_warn "MongoDB Shell indisponível"
                ;;
            rhel)
                cat > /etc/yum.repos.d/mongodb-org-7.0.repo << 'EOF'
[mongodb-org-7.0]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/$releasever/mongodb-org/7.0/$basearch/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-7.0.asc
EOF
                $CMD_INSTALL mongodb-mongosh 2>/dev/null || log_warn "MongoDB Shell indisponível"
                ;;
            arch)
                pkg_install "mongodb-tools" "MongoDB tools" 2>/dev/null || \
                pkg_install "mongosh" "MongoDB Shell (AUR)" 2>/dev/null || log_warn "MongoDB Shell indisponível"
                ;;
            suse)
                $CMD_INSTALL mongosh 2>/dev/null || log_warn "MongoDB Shell indisponível"
                ;;
        esac
    fi

    log_ok "Ferramentas de banco de dados instaladas!"
}

do_devops_tools() {
    log_section "17. FERRAMENTAS DEVOPS E CLOUD"

    log_info "Instalando ferramentas DevOps..."

    # kubectl
    if ! cmd_exists kubectl; then
        log_info "Instalando kubectl..."
        local kubectl_arch="amd64"
        [[ "$ARCH" == "aarch64" ]] && kubectl_arch="arm64"

        local k8s_version=$(curl -L -s https://dl.k8s.io/release/stable.txt 2>/dev/null || echo "v1.32.0")
        curl -fsSL "https://dl.k8s.io/release/$k8s_version/bin/linux/$kubectl_arch/kubectl" -o /usr/local/bin/kubectl 2>/dev/null && {
            chmod +x /usr/local/bin/kubectl
            log_ok "kubectl instalado!"
        } || log_warn "kubectl não pôde ser baixado"
    fi

    # Helm
    if ! cmd_exists helm; then
        log_info "Instalando Helm..."
        curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash 2>/dev/null || \
        case "$OS_FAMILY" in
            debian) pkg_install "helm" "Helm" 2>/dev/null || true ;;
            rhel)   $CMD_INSTALL helm 2>/dev/null || true ;;
            arch)   pkg_install "helm" "Helm" 2>/dev/null || true ;;
            suse)   pkg_install "helm" "Helm" 2>/dev/null || true ;;
        esac
        cmd_exists helm && log_ok "Helm instalado!" || log_warn "Helm indisponível"
    fi

    # Terraform
    if ! cmd_exists terraform; then
        log_info "Instalando Terraform..."
        case "$OS_FAMILY" in
            debian)
                curl -fsSL https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /etc/apt/trusted.gpg.d/hashicorp.gpg 2>/dev/null || true
                # HashiCorp suporta apenas LTS do Ubuntu
                local HASHI_CODENAME=$(get_lts_codename)
                echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/trusted.gpg.d/hashicorp.gpg] https://apt.releases.hashicorp.com $HASHI_CODENAME main" | \
                    tee /etc/apt/sources.list.d/hashicorp.list > /dev/null 2>/dev/null || true
                $CMD_UPDATE 2>/dev/null || true
                $CMD_INSTALL terraform 2>/dev/null || log_warn "Terraform indisponível"
                ;;
            rhel)
                $CMD_INSTALL dnf-plugins-core 2>/dev/null || true
                dnf config-manager --add-repo https://rpm.releases.hashicorp.com/$OS_ID/hashicorp.repo 2>/dev/null || true
                $CMD_INSTALL terraform 2>/dev/null || log_warn "Terraform indisponível"
                ;;
            arch)
                pkg_install "terraform" "Terraform" 2>/dev/null || log_warn "Terraform indisponível"
                ;;
            suse)
                $CMD_INSTALL terraform 2>/dev/null || log_warn "Terraform indisponível"
                ;;
        esac
    fi

    # AWS CLI v2
    if ! cmd_exists aws; then
        log_info "Instalando AWS CLI..."
        local aws_arch="x86_64"
        [[ "$ARCH" == "aarch64" ]] && aws_arch="aarch64"

        curl -fsSL "https://awscli.amazonaws.com/awscli-exe-linux-$aws_arch.zip" -o "/tmp/awscliv2.zip" 2>/dev/null && {
            cd /tmp && unzip -q awscliv2.zip 2>/dev/null
            ./aws/install -i /usr/local/aws-cli -b /usr/local/bin 2>/dev/null || true
            rm -rf /tmp/awscliv2.zip /tmp/aws
            log_ok "AWS CLI instalado!"
        } || log_warn "AWS CLI não pôde ser baixado"
    fi

    # Azure CLI
    if ! cmd_exists az; then
        log_info "Instalando Azure CLI..."
        case "$OS_FAMILY" in
            debian)
                curl -fsSL https://aka.ms/InstallAzureCLIDeb | bash 2>/dev/null || \
                $CMD_INSTALL azure-cli 2>/dev/null || log_warn "Azure CLI indisponível"
                ;;
            rhel)
                $CMD_INSTALL azure-cli 2>/dev/null || {
                    rpm --import https://packages.microsoft.com/keys/microsoft.asc 2>/dev/null || true
                    dnf install --repo azure-cli azure-cli 2>/dev/null || log_warn "Azure CLI indisponível"
                }
                ;;
            arch)
                pkg_install "azure-cli" "Azure CLI" 2>/dev/null || log_warn "Azure CLI indisponível"
                ;;
            suse)
                $CMD_INSTALL azure-cli 2>/dev/null || log_warn "Azure CLI indisponível"
                ;;
        esac
    fi

    # Minikube
    if ! cmd_exists minikube; then
        log_info "Instalando Minikube..."
        local mk_arch="amd64"
        [[ "$ARCH" == "aarch64" ]] && mk_arch="arm64"

        curl -fsSL https://storage.googleapis.com/minikube/releases/latest/minikube-linux-$mk_arch -o /usr/local/bin/minikube 2>/dev/null && {
            chmod +x /usr/local/bin/minikube
            log_ok "Minikube instalado!"
        } || log_warn "Minikube não pôde ser baixado"
    else
        log_ok "Minikube já instalado!"
    fi

    log_ok "Ferramentas DevOps instaladas!"
}

do_bluetooth() {
    log_section "18. BLUETOOTH"

    # Verificar se há hardware Bluetooth
    local has_bt_usb=false
    if lsusb | grep -iE "bluetooth|wireless" &>/dev/null; then
        log_ok "Adaptador Bluetooth USB detectado"
        has_bt_usb=true
    else
        log_warn "Nenhum adaptador Bluetooth USB detectado - pulando configuração"
        return 0
    fi

    # Verificar módulos do kernel
    if ! lsmod | grep -q "btusb"; then
        log_info "Carregando módulo btusb..."
        modprobe btusb 2>/dev/null || {
            log_warn "Módulo btusb não disponível"
            return 0
        }
    fi

    # Instalar pacotes Bluetooth se necessário
    if ! systemctl list-unit-files | grep -q "bluetooth.service"; then
        log_info "Instalando pacotes Bluetooth..."
        case "$OS_FAMILY" in
            debian)
                pkg_install "bluez bluez-tools blueman" "pacotes Bluetooth" 2>/dev/null || \
                pkg_install "bluez bluez-tools" "pacotes Bluetooth básicos" 2>/dev/null || true
                ;;
            rhel)
                $CMD_INSTALL bluez bluez-tools 2>/dev/null || true
                if [[ "$PKG_MGR" == "dnf" ]]; then
                    $CMD_INSTALL blueman 2>/dev/null || true
                fi
                ;;
            arch)
                pkg_install "bluez bluez-tools blueman" "pacotes Bluetooth" 2>/dev/null || \
                pkg_install "bluez bluez-tools" "pacotes Bluetooth básicos" 2>/dev/null || true
                ;;
            suse)
                $CMD_INSTALL bluez bluez-tools 2>/dev/null || true
                ;;
        esac
        systemctl daemon-reload 2>/dev/null || true
    fi

    # Verificar e desbloquear rfkill
    if command -v rfkill &> /dev/null; then
        if rfkill list bluetooth 2>/dev/null | grep -q "Soft blocked: yes"; then
            log_warn "Bluetooth bloqueado por software - desbloqueando..."
            rfkill unblock bluetooth 2>/dev/null || true
        fi
    fi

    # Habilitar e iniciar serviço
    systemctl enable bluetooth 2>/dev/null || true
    systemctl restart bluetooth 2>/dev/null || true
    sleep 2

    if systemctl is-active --quiet bluetooth; then
        log_ok "Serviço Bluetooth ativo e habilitado"
    else
        log_warn "Serviço Bluetooth não pôde ser iniciado"
        return 0
    fi

    # Configurar controlador
    bluetoothctl <<EOF &>/dev/null
power off
power on
pairable on
discoverable on
agent on
default-agent
EOF

    sleep 1

    # Mostrar status
    log_info "Status do controlador:"
    bluetoothctl show 2>/dev/null | grep -E "Powered|Pairable|Discoverable" | while read -r line; do
        echo -e "  ${CYAN}•${NC} $line"
    done

    log_ok "Bluetooth configurado com sucesso!"
}

do_system_tweaks() {
    log_section "19. OTIMIZAÇÕES DO SISTEMA"

    log_info "Aplicando otimizações..."

    # Sysctl
    if ! grep -q "fs.inotify.max_user_watches" /etc/sysctl.conf 2>/dev/null; then
        echo "fs.inotify.max_user_watches=524288" >> /etc/sysctl.conf
        echo "fs.inotify.max_user_instances=512" >> /etc/sysctl.conf
    fi
    if ! grep -q "kernel.shmmax" /etc/sysctl.conf 2>/dev/null; then
        echo "kernel.shmmax=17179869184" >> /etc/sysctl.conf
    fi
    if ! grep -q "vm.swappiness" /etc/sysctl.conf 2>/dev/null; then
        echo "vm.swappiness=10" >> /etc/sysctl.conf
    fi

    sysctl -p 2>/dev/null || true

    # Limits
    if ! grep -q "nofile" /etc/security/limits.conf 2>/dev/null; then
        echo "* soft nofile 65536" >> /etc/security/limits.conf
        echo "* hard nofile 65536" >> /etc/security/limits.conf
        echo "* soft nproc 65536" >> /etc/security/limits.conf
        echo "* hard nproc 65536" >> /etc/security/limits.conf
    fi

    log_ok "Otimizações aplicadas!"
}

do_cleanup() {
    log_section "20. LIMPEZA FINAL"

    log_info "Limpando pacotes e cache..."
    $CMD_AUTOREMOVE 2>/dev/null || true
    $CMD_AUTOCLEAN 2>/dev/null || true
    $CMD_CLEAN 2>/dev/null || true

    cmd_exists npm && npm cache clean --force 2>/dev/null || true

    log_ok "Limpeza concluída!"
}

do_summary() {
    log_section "21. RESUMO DA INSTALAÇÃO"

    echo -e "${GREEN}============================================${NC}"
    echo -e "${GREEN}  INSTALAÇÃO CONCLUÍDA COM SUCESSO!${NC}"
    echo -e "${GREEN}============================================${NC}"
    echo ""
    echo -e "${BLUE}Sistema:${NC} $OS_NAME"
    echo -e "${BLUE}Kernel:${NC} $(uname -r)"
    echo -e "${BLUE}CPU:${NC} $(lscpu 2>/dev/null | grep -iE 'model name|processador|processor' | head -1 | cut -d: -f2 | xargs || cat /proc/cpuinfo 2>/dev/null | grep -i 'model name' | head -1 | cut -d: -f2 | xargs || echo 'N/A')"
    echo -e "${BLUE}GPU:${NC} $(lspci 2>/dev/null | grep -iE 'VGA|3D|Display' | head -1 | cut -d: -f3- | xargs || echo 'N/A')"
    echo -e "${BLUE}RAM:${NC} $(free -h 2>/dev/null | grep Mem | awk '{print $2}' || echo 'N/A')"
    echo ""
    echo -e "${BLUE}Ferramentas instaladas/verificadas:${NC}"
    echo -e "  $(cmd_exists git && echo '✓' || echo '✗') Git, Curl, Wget, Htop"
    echo -e "  $(cmd_exists java && echo '✓' || echo '✗') OpenJDK $(java -version 2>&1 | head -1 | cut -d'"' -f2 || echo 'N/A')"
    echo -e "  $(cmd_exists mvn && echo '✓' || echo '✗') Maven | $(cmd_exists gradle && echo '✓' || echo '✗') Gradle"
    echo -e "  $(cmd_exists node && echo '✓' || echo '✗') Node.js $(node -v 2>/dev/null || echo 'N/A') | $(cmd_exists npm && echo '✓' || echo '✗') npm"
    echo -e "  $(cmd_exists python3 && echo '✓' || echo '✗') Python $(python3 --version 2>/dev/null | cut -d' ' -f2 || echo 'N/A')"
    echo -e "  $(cmd_exists dotnet && echo '✓' || echo '✗') .NET SDK $(dotnet --version 2>/dev/null || echo 'N/A')"
    echo -e "  $(cmd_exists docker && echo '✓' || echo '✗') Docker $(docker --version 2>/dev/null | cut -d' ' -f3 || echo 'N/A')"
    echo -e "  $(cmd_exists mariadb && echo '✓' || cmd_exists mysql && echo '✓' || echo '✗') MariaDB/MySQL"
    echo -e "  $(cmd_exists sqlcmd && echo '✓' || echo '✗') MS SQL Server Tools"
    echo -e "  $(cmd_exists dbeaver-ce && echo '✓' || cmd_exists dbeaver && echo '✓' || echo '✗') DBeaver"
    echo -e "  $(cmd_exists psql && echo '✓' || echo '✗') PostgreSQL Client | $(cmd_exists sqlite3 && echo '✓' || echo '✗') SQLite"
    echo -e "  $(cmd_exists redis-cli && echo '✓' || echo '✗') Redis | $(cmd_exists mongosh && echo '✓' || echo '✗') MongoDB Shell"
    echo -e "  $(cmd_exists kubectl && echo '✓' || echo '✗') kubectl | $(cmd_exists helm && echo '✓' || echo '✗') Helm | $(cmd_exists minikube && echo '✓' || echo '✗') Minikube"
    echo -e "  $(cmd_exists terraform && echo '✓' || echo '✗') Terraform | $(cmd_exists aws && echo '✓' || echo '✗') AWS CLI | $(cmd_exists az && echo '✓' || echo '✗') Azure CLI"
    echo -e "  $(cmd_exists code && echo '✓' || echo '✗') VS Code | $(cmd_exists google-chrome && echo '✓' || echo '✗') Chrome"
    echo ""
    echo -e "${BLUE}Bancos de Dados Configurados:${NC}"
    echo -e "  • MariaDB/MySQL - usuário: ${CURRENT_USER} (senha em ~/.db-credentials/mariadb.conf)"
    echo -e "  • PostgreSQL - usuário: ${CURRENT_USER} (senha em ~/.db-credentials/postgresql.conf)"
    echo -e "  • DBeaver - conexões configuradas para MySQL, PostgreSQL e SQL Server"
    echo ""
    echo -e "${YELLOW}NOTAS:${NC}"
    echo -e "  • Reinicie o sistema para aplicar drivers NVIDIA"
    echo -e "  • Faça logout/login para usar Docker sem sudo"
    echo -e "  • Credenciais dos bancos: ~/.db-credentials/"
    echo -e "  • Configurações do DBeaver: ~/.local/share/DBeaverData/"
    echo -e "  • Script reutilizável: pode rodar novamente com segurança"
    echo ""
    echo -e "${BLUE}Log de execução:${NC} $LOG_FILE"
    echo ""
    log_ok "Script de configuração concluído!"
}

###############################################################################
# MAIN
###############################################################################

main() {
    # Verificar root
    if [ "$EUID" -ne 0 ]; then
        log_error "Este script deve ser executado como root (use sudo)"
        exit 1
    fi

    echo ""
    echo -e "${GREEN}"
    echo " ╔═══════════════════════════════════════════════════════╗"
    echo " ║                 ⚧  TRANSDEVS                          ║"
    echo " ║                                                       ║"
    echo " ║         SETUP LINUX AUTOMÁTICO - MULTI-DISTRO         ║"
    echo " ║                                                       ║"
    echo " ╚═══════════════════════════════════════════════════════╝"
    echo -e "${NC}"

    # Detectar SO
    detect_os
    print_system_info

    # Executar seções
    do_cleanup_invalid_repos  # Limpar repos inválidos de execuções anteriores
    do_system_update
    do_locale_timezone
    do_repos
    do_dev_tools
    do_java
    do_nodejs
    do_python
    do_dotnet
    do_docker
    do_mssql
    do_mariadb
    do_dbeaver
    do_chrome
    do_vscode
    do_nvidia
    do_bluetooth
    do_db_extra_tools
    do_devops_tools
    do_system_tweaks
    do_cleanup
    do_summary
}

# Executar
main "$@"
