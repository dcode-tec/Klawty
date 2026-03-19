#!/usr/bin/env bash
set -euo pipefail

# Klawty Agent OS — One-command installer
# Usage: curl -fsSL https://klawty.ai/install.sh | bash
#
# Flags:
#   --no-onboard    Skip the interactive onboard wizard
#   --dir <path>    Install location (default: ~/klawty)

# ── Colors & Symbols ──────────────────────────────────────────────────────────
BOLD='\033[1m'
DIM='\033[2m'
CYAN='\033[38;2;0;229;204m'
GREEN='\033[38;2;80;250;123m'
YELLOW='\033[38;2;255;176;32m'
RED='\033[38;2;230;57;70m'
BLUE='\033[38;2;100;149;237m'
MAGENTA='\033[38;2;189;147;249m'
NC='\033[0m'

CHECK="${GREEN}✓${NC}"
ARROW="${CYAN}→${NC}"
CROSS="${RED}✗${NC}"
WARN_SYM="${YELLOW}⚠${NC}"

KLAWTY_REPO="https://github.com/klawty/klawty.git"
KLAWTY_VERSION="1.0.0"
NODE_MIN_MAJOR=22
INSTALL_DIR="${HOME}/klawty"
RUN_ONBOARD=true

# ── Helpers ───────────────────────────────────────────────────────────────────
info()    { printf "  ${ARROW} %b\n" "$1"; }
success() { printf "  ${CHECK} %b\n" "$1"; }
warn()    { printf "  ${WARN_SYM} %b\n" "$1"; }
fail()    { printf "  ${CROSS} %b\n" "$1" >&2; exit 1; }

banner() {
    printf "\n"
    printf "  ${MAGENTA}${BOLD}"
    printf "  ██╗  ██╗██╗      █████╗ ██╗    ██╗████████╗██╗   ██╗\n"
    printf "  ██║ ██╔╝██║     ██╔══██╗██║    ██║╚══██╔══╝╚██╗ ██╔╝\n"
    printf "  █████╔╝ ██║     ███████║██║ █╗ ██║   ██║    ╚████╔╝ \n"
    printf "  ██╔═██╗ ██║     ██╔══██║██║███╗██║   ██║     ╚██╔╝  \n"
    printf "  ██║  ██╗███████╗██║  ██║╚███╔███╔╝   ██║      ██║   \n"
    printf "  ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝ ╚══╝╚══╝    ╚═╝      ╚═╝   \n"
    printf "${NC}\n"
    printf "  ${DIM}Agent OS — v${KLAWTY_VERSION}${NC}\n\n"
}

# ── Parse Arguments ───────────────────────────────────────────────────────────
while [[ $# -gt 0 ]]; do
    case "$1" in
        --no-onboard) RUN_ONBOARD=false; shift ;;
        --dir)
            if [[ -z "${2:-}" ]]; then fail "--dir requires a path argument"; fi
            INSTALL_DIR="$2"; shift 2 ;;
        *) fail "Unknown option: $1" ;;
    esac
done

# ── Detect OS ─────────────────────────────────────────────────────────────────
detect_os() {
    local uname_out
    uname_out="$(uname -s)"
    case "${uname_out}" in
        Darwin*)  OS="macos" ;;
        Linux*)
            if grep -qEi "(Microsoft|WSL)" /proc/version 2>/dev/null; then
                OS="wsl"
            else
                OS="linux"
            fi
            ;;
        *) fail "Unsupported operating system: ${uname_out}" ;;
    esac
}

# ── Check / Install Node.js ──────────────────────────────────────────────────
ensure_node() {
    # Source nvm if available but not yet loaded
    if [[ -z "${NVM_DIR:-}" ]]; then
        export NVM_DIR="${HOME}/.nvm"
    fi
    if [[ -s "${NVM_DIR}/nvm.sh" ]]; then
        # shellcheck source=/dev/null
        source "${NVM_DIR}/nvm.sh"
    fi

    if command -v node &>/dev/null; then
        local node_major
        node_major="$(node -v | sed 's/v//' | cut -d. -f1)"
        if [[ "${node_major}" -ge "${NODE_MIN_MAJOR}" ]]; then
            success "Node.js $(node -v) detected"
            return 0
        fi
        warn "Node.js $(node -v) found but v${NODE_MIN_MAJOR}+ required"
    fi

    info "Installing Node.js ${NODE_MIN_MAJOR} via nvm..."

    if ! command -v nvm &>/dev/null; then
        info "Installing nvm..."
        curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
        export NVM_DIR="${HOME}/.nvm"
        # shellcheck source=/dev/null
        source "${NVM_DIR}/nvm.sh"
    fi

    nvm install "${NODE_MIN_MAJOR}" --default
    nvm use "${NODE_MIN_MAJOR}"
    success "Node.js $(node -v) installed via nvm"
}

# ── Check Docker ──────────────────────────────────────────────────────────────
check_docker() {
    if command -v docker &>/dev/null; then
        if docker info &>/dev/null 2>&1; then
            success "Docker is installed and running"
        else
            warn "Docker is installed but not running — start it before using Qdrant"
        fi
    else
        warn "Docker not found — needed for Qdrant vector memory"
        printf "\n"
        info "Install Docker:"
        case "${OS}" in
            macos) info "  ${BLUE}https://docs.docker.com/desktop/install/mac-install/${NC}" ;;
            linux) info "  ${BLUE}https://docs.docker.com/engine/install/${NC}" ;;
            wsl)   info "  ${BLUE}https://docs.docker.com/desktop/install/windows-install/${NC} (with WSL backend)" ;;
        esac
        printf "\n"
    fi
}

# ── Check / Install pnpm ─────────────────────────────────────────────────────
ensure_pnpm() {
    if command -v pnpm &>/dev/null; then
        success "pnpm $(pnpm -v) detected"
        return 0
    fi

    info "Installing pnpm..."
    if command -v corepack &>/dev/null; then
        corepack enable
        corepack prepare pnpm@latest --activate
    else
        npm install -g pnpm
    fi
    success "pnpm $(pnpm -v) installed"
}

# ── Clone or Download Klawty ─────────────────────────────────────────────────
install_klawty() {
    if [[ -d "${INSTALL_DIR}" ]]; then
        if [[ -f "${INSTALL_DIR}/klawty.json" ]] || [[ -f "${INSTALL_DIR}/package.json" ]]; then
            success "Klawty already installed at ${INSTALL_DIR}"
            info "Pulling latest updates..."
            (cd "${INSTALL_DIR}" && git pull --rebase 2>/dev/null || true)
            return 0
        fi
    fi

    info "Cloning Klawty to ${INSTALL_DIR}..."
    if command -v git &>/dev/null; then
        git clone --depth 1 "${KLAWTY_REPO}" "${INSTALL_DIR}"
    else
        fail "git is required — install it with: ${BOLD}brew install git${NC} (macOS) or ${BOLD}apt install git${NC} (Linux)"
    fi
    success "Klawty cloned to ${INSTALL_DIR}"
}

# ── Install Dependencies ─────────────────────────────────────────────────────
install_deps() {
    info "Installing dependencies..."
    (cd "${INSTALL_DIR}" && pnpm install --frozen-lockfile 2>/dev/null || pnpm install)
    success "Dependencies installed"
}

# ── Add to PATH ──────────────────────────────────────────────────────────────
add_to_path() {
    local shell_rc=""
    local export_line="export PATH=\"${INSTALL_DIR}/bin:\$PATH\""

    case "${SHELL:-/bin/bash}" in
        */zsh)  shell_rc="${HOME}/.zshrc" ;;
        */bash) shell_rc="${HOME}/.bashrc" ;;
        *)      shell_rc="${HOME}/.profile" ;;
    esac

    if [[ -f "${shell_rc}" ]] && grep -qF "${INSTALL_DIR}/bin" "${shell_rc}" 2>/dev/null; then
        success "PATH already configured in ${shell_rc}"
        return 0
    fi

    if [[ -n "${shell_rc}" ]]; then
        printf "\n# Klawty Agent OS\n%s\n" "${export_line}" >> "${shell_rc}"
        success "Added Klawty to PATH in ${shell_rc}"
    fi

    export PATH="${INSTALL_DIR}/bin:${PATH}"
}

# ── Summary ───────────────────────────────────────────────────────────────────
print_summary() {
    printf "\n"
    printf "  ${GREEN}${BOLD}Installation complete!${NC}\n"
    printf "  ${DIM}─────────────────────────────────────────${NC}\n"
    printf "  ${BOLD}Location:${NC}  %s\n" "${INSTALL_DIR}"
    printf "  ${BOLD}OS:${NC}        %s\n" "${OS}"
    printf "  ${BOLD}Node:${NC}      %s\n" "$(node -v 2>/dev/null || echo 'not found')"
    printf "  ${BOLD}pnpm:${NC}      %s\n" "$(pnpm -v 2>/dev/null || echo 'not found')"
    printf "  ${BOLD}Docker:${NC}    %s\n" "$(docker -v 2>/dev/null | head -1 || echo 'not installed')"
    printf "\n"
    printf "  ${BOLD}Next steps:${NC}\n"
    if [[ "${RUN_ONBOARD}" == false ]]; then
        printf "    ${ARROW} Run the onboard wizard:  ${CYAN}klawty onboard${NC}\n"
    fi
    printf "    ${ARROW} Start your agents:       ${CYAN}klawty start${NC}\n"
    printf "    ${ARROW} Check system health:      ${CYAN}klawty status${NC}\n"
    printf "    ${ARROW} Read the docs:            ${BLUE}https://docs.klawty.ai${NC}\n"
    printf "\n"
}

# ── Main ──────────────────────────────────────────────────────────────────────
main() {
    banner

    info "Detecting environment..."
    detect_os
    success "Detected ${BOLD}${OS}${NC}"

    printf "\n  ${BOLD}Checking prerequisites...${NC}\n"
    ensure_node
    ensure_pnpm
    check_docker

    printf "\n  ${BOLD}Installing Klawty...${NC}\n"
    install_klawty
    install_deps
    add_to_path

    if [[ "${RUN_ONBOARD}" == true ]]; then
        printf "\n  ${BOLD}Starting onboard wizard...${NC}\n\n"
        if [[ -f "${INSTALL_DIR}/scripts/onboard.sh" ]]; then
            bash "${INSTALL_DIR}/scripts/onboard.sh"
        elif command -v klawty &>/dev/null; then
            klawty onboard
        else
            warn "Could not find onboard script — run ${CYAN}klawty onboard${NC} manually"
        fi
    fi

    print_summary
}

main "$@"
