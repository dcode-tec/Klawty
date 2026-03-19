#!/usr/bin/env bash
set -euo pipefail

# Klawty Agent OS — Interactive Onboard Wizard
# Usage: klawty onboard  OR  ./scripts/onboard.sh

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

KLAWTY_VERSION="1.0.0"

# ── Resolve workspace root ───────────────────────────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE="$(cd "${SCRIPT_DIR}/.." && pwd)"

# ── State variables ───────────────────────────────────────────────────────────
LICENSE_KEY=""
OPENROUTER_API_KEY=""
INDUSTRY="generic"
INDUSTRY_NUM=1
CHANNEL="none"
CHANNEL_TOKEN=""
QDRANT_URL="http://localhost:6333"
DEV_MODE=false

# ── Helpers ───────────────────────────────────────────────────────────────────
info()    { printf "  ${ARROW} %b\n" "$1"; }
success() { printf "  ${CHECK} %b\n" "$1"; }
warn()    { printf "  ${WARN_SYM} %b\n" "$1"; }
fail()    { printf "  ${CROSS} %b\n" "$1" >&2; exit 1; }

prompt() {
    local msg="$1"
    local var_name="$2"
    local default="${3:-}"
    local input

    if [[ -n "${default}" ]]; then
        printf "  ${CYAN}?${NC} ${BOLD}%b${NC} ${DIM}[%s]${NC}: " "${msg}" "${default}"
    else
        printf "  ${CYAN}?${NC} ${BOLD}%b${NC}: " "${msg}"
    fi

    read -r input
    if [[ -z "${input}" ]] && [[ -n "${default}" ]]; then
        input="${default}"
    fi
    eval "${var_name}=\"\${input}\""
}

prompt_secret() {
    local msg="$1"
    local var_name="$2"
    local input

    printf "  ${CYAN}?${NC} ${BOLD}%b${NC}: " "${msg}"
    read -rs input
    printf "\n"
    eval "${var_name}=\"\${input}\""
}

divider() {
    printf "\n  ${DIM}────────────────────────────────────────────────${NC}\n\n"
}

# ── Banner ────────────────────────────────────────────────────────────────────
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
    printf "  ${DIM}Onboard Wizard — v${KLAWTY_VERSION}${NC}\n"
    printf "  ${DIM}Configure your agent team in under 2 minutes.${NC}\n"
}

# ── Step 1: License Key ──────────────────────────────────────────────────────
step_license() {
    printf "\n  ${BOLD}${BLUE}[1/7]${NC} ${BOLD}License Key${NC}\n\n"

    info "Enter your Klawty license key."
    info "Get one at ${BLUE}https://klawty.ai/pricing${NC}"
    info "Press Enter to skip (dev mode — limited features)."
    printf "\n"

    prompt_secret "License key" LICENSE_KEY

    if [[ -z "${LICENSE_KEY}" ]]; then
        DEV_MODE=true
        warn "Running in dev mode — some features are restricted"
    else
        success "License key saved"
    fi
}

# ── Step 2: LLM Provider ─────────────────────────────────────────────────────
step_llm() {
    divider
    printf "  ${BOLD}${BLUE}[2/7]${NC} ${BOLD}LLM Provider${NC}\n\n"

    info "Klawty uses OpenRouter for LLM inference."
    info "Get your API key at ${BLUE}https://openrouter.ai/keys${NC}"
    printf "\n"

    prompt_secret "OpenRouter API key" OPENROUTER_API_KEY

    if [[ -z "${OPENROUTER_API_KEY}" ]]; then
        fail "OpenRouter API key is required — agents need an LLM to function"
    fi

    # Validate the key
    info "Validating API key..."
    local http_code
    http_code="$(curl -so /dev/null -w '%{http_code}' \
        -H "Authorization: Bearer ${OPENROUTER_API_KEY}" \
        "https://openrouter.ai/api/v1/models" 2>/dev/null || echo "000")"

    if [[ "${http_code}" == "200" ]]; then
        success "OpenRouter API key is valid"
    elif [[ "${http_code}" == "000" ]]; then
        warn "Could not reach OpenRouter — check your network connection"
        warn "Continuing with the provided key (will validate on first use)"
    else
        warn "OpenRouter returned HTTP ${http_code} — key may be invalid"
        printf "\n"
        prompt "Continue anyway? (y/N)" CONTINUE_LLM "N"
        if [[ "${CONTINUE_LLM}" != "y" ]] && [[ "${CONTINUE_LLM}" != "Y" ]]; then
            fail "Aborted — fix your API key and rerun ${CYAN}klawty onboard${NC}"
        fi
    fi
}

# ── Step 3: Industry ─────────────────────────────────────────────────────────
step_industry() {
    divider
    printf "  ${BOLD}${BLUE}[3/7]${NC} ${BOLD}Industry${NC}\n\n"

    info "Select your industry to auto-configure agents:"
    printf "\n"
    printf "    ${BOLD}1)${NC}  Generic (custom setup)\n"
    printf "    ${BOLD}2)${NC}  Restaurants & Hospitality\n"
    printf "    ${BOLD}3)${NC}  Real Estate\n"
    printf "    ${BOLD}4)${NC}  Construction & Trades\n"
    printf "    ${BOLD}5)${NC}  Resellers & E-commerce\n"
    printf "    ${BOLD}6)${NC}  Accounting & Finance\n"
    printf "    ${BOLD}7)${NC}  Law Firms & Legal\n"
    printf "\n"

    prompt "Select industry (1-7)" INDUSTRY_NUM "1"

    case "${INDUSTRY_NUM}" in
        1) INDUSTRY="generic" ;;
        2) INDUSTRY="restaurants" ;;
        3) INDUSTRY="real-estate" ;;
        4) INDUSTRY="construction" ;;
        5) INDUSTRY="resellers" ;;
        6) INDUSTRY="accounting" ;;
        7) INDUSTRY="law-firms" ;;
        *) warn "Invalid selection — defaulting to Generic"; INDUSTRY="generic"; INDUSTRY_NUM=1 ;;
    esac

    success "Industry set to ${BOLD}${INDUSTRY}${NC}"
}

# ── Step 4: Channel ──────────────────────────────────────────────────────────
step_channel() {
    divider
    printf "  ${BOLD}${BLUE}[4/7]${NC} ${BOLD}Communication Channel${NC}\n\n"

    info "How should your agents communicate?"
    printf "\n"
    printf "    ${BOLD}1)${NC}  Discord\n"
    printf "    ${BOLD}2)${NC}  Slack\n"
    printf "    ${BOLD}3)${NC}  Telegram\n"
    printf "    ${BOLD}4)${NC}  None (terminal only)\n"
    printf "\n"

    local channel_num
    prompt "Select channel (1-4)" channel_num "4"

    case "${channel_num}" in
        1) CHANNEL="discord" ;;
        2) CHANNEL="slack" ;;
        3) CHANNEL="telegram" ;;
        4) CHANNEL="none" ;;
        *) warn "Invalid selection — defaulting to terminal only"; CHANNEL="none" ;;
    esac

    if [[ "${CHANNEL}" != "none" ]]; then
        printf "\n"
        local token_label
        case "${CHANNEL}" in
            discord)  token_label="Discord bot token" ;;
            slack)    token_label="Slack bot token (xoxb-...)" ;;
            telegram) token_label="Telegram bot token" ;;
        esac

        prompt_secret "${token_label}" CHANNEL_TOKEN

        if [[ -z "${CHANNEL_TOKEN}" ]]; then
            warn "No token provided — channel will be configured but not connected"
        else
            success "${CHANNEL} token saved"
        fi
    fi

    success "Channel set to ${BOLD}${CHANNEL}${NC}"
}

# ── Step 5: Docker / Qdrant ──────────────────────────────────────────────────
step_docker() {
    divider
    printf "  ${BOLD}${BLUE}[5/7]${NC} ${BOLD}Vector Memory (Qdrant)${NC}\n\n"

    if ! command -v docker &>/dev/null; then
        warn "Docker not found — Qdrant requires Docker"
        info "Install Docker and rerun ${CYAN}klawty onboard${NC} to enable vector memory"
        info "Agents will work without Qdrant (file-based memory only)"
        return 0
    fi

    if ! docker info &>/dev/null 2>&1; then
        warn "Docker is installed but not running"
        info "Start Docker Desktop and rerun to enable Qdrant"
        return 0
    fi

    success "Docker is running"

    # Check if Qdrant is already running
    if curl -so /dev/null "http://localhost:6333/healthz" 2>/dev/null; then
        success "Qdrant is already running on port 6333"
        return 0
    fi

    printf "\n"
    local start_qdrant
    prompt "Start Qdrant now? (Y/n)" start_qdrant "Y"

    if [[ "${start_qdrant}" == "n" ]] || [[ "${start_qdrant}" == "N" ]]; then
        info "Skipping Qdrant — start it later with: ${CYAN}docker compose up -d qdrant${NC}"
        return 0
    fi

    info "Starting Qdrant..."
    if [[ -f "${WORKSPACE}/docker-compose.yml" ]]; then
        (cd "${WORKSPACE}" && docker compose up -d qdrant 2>/dev/null) || true
    else
        docker run -d --name klawty-qdrant \
            -p 6333:6333 -p 6334:6334 \
            -v "${WORKSPACE}/data/qdrant:/qdrant/storage" \
            qdrant/qdrant:latest 2>/dev/null || true
    fi

    # Wait briefly and verify
    sleep 2
    if curl -so /dev/null "http://localhost:6333/healthz" 2>/dev/null; then
        success "Qdrant is running on port 6333"
    else
        warn "Qdrant may still be starting — check with: ${CYAN}curl http://localhost:6333/healthz${NC}"
    fi
}

# ── Step 6: Write .env ───────────────────────────────────────────────────────
step_write_env() {
    divider
    printf "  ${BOLD}${BLUE}[6/7]${NC} ${BOLD}Writing Configuration${NC}\n\n"

    local env_file="${WORKSPACE}/.env"

    # Back up existing .env
    if [[ -f "${env_file}" ]]; then
        cp "${env_file}" "${env_file}.bak"
        info "Backed up existing .env to .env.bak"
    fi

    {
        echo "# Klawty Agent OS — generated by onboard wizard"
        echo "# $(date -u '+%Y-%m-%dT%H:%M:%SZ')"
        echo ""
        echo "# ── License ─────────────────────────────────────"
        if [[ -n "${LICENSE_KEY}" ]]; then
            echo "LICENSE_KEY=${LICENSE_KEY}"
        else
            echo "# LICENSE_KEY=  (dev mode)"
        fi
        echo ""
        echo "# ── LLM Provider ────────────────────────────────"
        echo "OPENROUTER_API_KEY=${OPENROUTER_API_KEY}"
        echo ""
        echo "# ── Vector Memory ─────────────────────────────────"
        echo "QDRANT_URL=${QDRANT_URL}"
        echo ""
        echo "# ── Channel ───────────────────────────────────────"
        echo "CHANNEL=${CHANNEL}"
        if [[ "${CHANNEL}" != "none" ]] && [[ -n "${CHANNEL_TOKEN}" ]]; then
            local token_var
            case "${CHANNEL}" in
                discord)  token_var="DISCORD_BOT_TOKEN" ;;
                slack)    token_var="SLACK_BOT_TOKEN" ;;
                telegram) token_var="TELEGRAM_BOT_TOKEN" ;;
            esac
            echo "${token_var}=${CHANNEL_TOKEN}"
        fi
        echo ""
        echo "# ── Industry ──────────────────────────────────────"
        echo "INDUSTRY=${INDUSTRY}"
    } > "${env_file}"

    chmod 600 "${env_file}"
    success "Wrote ${DIM}.env${NC} (permissions: 600)"
}

# ── Step 6b: Write klawty.json ────────────────────────────────────────────────
step_write_config() {
    local config_file="${WORKSPACE}/klawty.json"

    # Map industry to agent presets
    local agents_block
    case "${INDUSTRY}" in
        restaurants)
            agents_block='{
      "host": { "role": "coordinator", "model_tier": "workhorse" },
      "chef-ops": { "role": "operations", "model_tier": "workhorse", "skills": ["inventory", "menu-costing"] },
      "front-house": { "role": "client-manager", "model_tier": "workhorse", "skills": ["reservations", "reviews"] },
      "kitchen-intel": { "role": "analyst", "model_tier": "capable", "skills": ["food-cost", "waste-tracking"] },
      "social": { "role": "content-writer", "model_tier": "nano", "skills": ["social-media", "local-seo"] }
    }' ;;
        real-estate)
            agents_block='{
      "broker": { "role": "coordinator", "model_tier": "workhorse" },
      "listings": { "role": "content-writer", "model_tier": "workhorse", "skills": ["property-descriptions", "mls-sync"] },
      "leads": { "role": "sales", "model_tier": "workhorse", "skills": ["lead-scoring", "follow-up"] },
      "market": { "role": "analyst", "model_tier": "capable", "skills": ["comps", "market-trends"] },
      "compliance": { "role": "safety-monitor", "model_tier": "workhorse", "skills": ["fair-housing", "disclosure"] }
    }' ;;
        construction)
            agents_block='{
      "foreman": { "role": "coordinator", "model_tier": "workhorse" },
      "estimator": { "role": "finance", "model_tier": "capable", "skills": ["takeoffs", "bid-prep"] },
      "scheduler": { "role": "operations", "model_tier": "workhorse", "skills": ["gantt", "resource-leveling"] },
      "safety": { "role": "safety-monitor", "model_tier": "workhorse", "skills": ["osha", "incident-tracking"] },
      "client-pm": { "role": "client-manager", "model_tier": "workhorse", "skills": ["change-orders", "progress-reports"] }
    }' ;;
        resellers)
            agents_block='{
      "ops": { "role": "coordinator", "model_tier": "workhorse" },
      "catalog": { "role": "content-writer", "model_tier": "workhorse", "skills": ["product-descriptions", "seo"] },
      "orders": { "role": "operations", "model_tier": "workhorse", "skills": ["fulfillment", "inventory-sync"] },
      "pricing": { "role": "analyst", "model_tier": "capable", "skills": ["competitor-pricing", "margin-analysis"] },
      "support": { "role": "client-manager", "model_tier": "nano", "skills": ["returns", "customer-faq"] }
    }' ;;
        accounting)
            agents_block='{
      "partner": { "role": "coordinator", "model_tier": "workhorse" },
      "bookkeeper": { "role": "finance", "model_tier": "capable", "skills": ["reconciliation", "categorization"] },
      "tax-prep": { "role": "researcher", "model_tier": "capable", "skills": ["tax-calendar", "deduction-finder"] },
      "client-mgr": { "role": "client-manager", "model_tier": "workhorse", "skills": ["document-requests", "deadlines"] },
      "audit": { "role": "safety-monitor", "model_tier": "workhorse", "skills": ["anomaly-detection", "compliance-check"] }
    }' ;;
        law-firms)
            agents_block='{
      "managing": { "role": "coordinator", "model_tier": "workhorse" },
      "research": { "role": "researcher", "model_tier": "power", "skills": ["case-law", "statute-lookup"] },
      "paralegal": { "role": "operations", "model_tier": "workhorse", "skills": ["document-assembly", "filing-deadlines"] },
      "intake": { "role": "client-manager", "model_tier": "workhorse", "skills": ["conflict-check", "client-screening"] },
      "billing": { "role": "finance", "model_tier": "workhorse", "skills": ["time-entries", "trust-accounting"] }
    }' ;;
        *)
            agents_block='{
      "coordinator": { "role": "coordinator", "model_tier": "workhorse" },
      "researcher": { "role": "researcher", "model_tier": "capable" },
      "writer": { "role": "content-writer", "model_tier": "workhorse" },
      "analyst": { "role": "analyst", "model_tier": "capable" },
      "monitor": { "role": "safety-monitor", "model_tier": "nano" }
    }' ;;
    esac

    cat > "${config_file}" << JSONEOF
{
  "version": "1.0",
  "name": "klawty-${INDUSTRY}",
  "industry": "${INDUSTRY}",
  "channel": "${CHANNEL}",
  "models": {
    "nano": "openrouter/google/gemini-flash-1.5-8b",
    "workhorse": "openrouter/moonshotai/kimi-k2",
    "capable": "openrouter/anthropic/claude-sonnet-4",
    "power": "openrouter/anthropic/claude-opus-4",
    "premium": "openrouter/anthropic/claude-opus-4"
  },
  "agents": ${agents_block},
  "memory": {
    "backend": "qdrant",
    "url": "${QDRANT_URL}",
    "collection": "klawty-${INDUSTRY}"
  },
  "policy": "klawty-policy.yaml"
}
JSONEOF

    success "Wrote ${DIM}klawty.json${NC} with ${INDUSTRY} agent presets"
}

# ── Step 7: Activate License ─────────────────────────────────────────────────
step_activate() {
    divider
    printf "  ${BOLD}${BLUE}[7/7]${NC} ${BOLD}Activation${NC}\n\n"

    if [[ "${DEV_MODE}" == true ]]; then
        info "Skipping license activation (dev mode)"
        return 0
    fi

    info "Activating license..."

    # Generate machine fingerprint
    local fingerprint
    if command -v hostname &>/dev/null; then
        fingerprint="$(hostname)-$(uname -m)-$(whoami)"
    else
        fingerprint="klawty-$(uname -m)-$(date +%s)"
    fi
    fingerprint="$(echo -n "${fingerprint}" | shasum -a 256 | cut -d' ' -f1)"

    local http_code
    http_code="$(curl -so /dev/null -w '%{http_code}' \
        -X POST "https://ai-agent-builder.ai/api/license/activate" \
        -H "Content-Type: application/json" \
        -d "{\"key\": \"${LICENSE_KEY}\", \"fingerprint\": \"${fingerprint}\"}" \
        2>/dev/null || echo "000")"

    if [[ "${http_code}" == "200" ]] || [[ "${http_code}" == "201" ]]; then
        success "License activated"
    elif [[ "${http_code}" == "000" ]]; then
        warn "Could not reach activation server — will retry on first start"
    else
        warn "Activation returned HTTP ${http_code} — will retry on first start"
    fi
}

# ── Start Agents ──────────────────────────────────────────────────────────────
step_start() {
    divider
    printf "  ${BOLD}Ready to launch!${NC}\n\n"

    local start_now
    prompt "Start agents now? (Y/n)" start_now "Y"

    if [[ "${start_now}" == "n" ]] || [[ "${start_now}" == "N" ]]; then
        info "Start later with: ${CYAN}klawty start${NC}"
        return 0
    fi

    info "Starting agents..."
    if command -v klawty &>/dev/null; then
        klawty start
    elif [[ -f "${WORKSPACE}/bin/klawty" ]]; then
        "${WORKSPACE}/bin/klawty" start
    else
        warn "CLI not found in PATH — run: ${CYAN}cd ${WORKSPACE} && pnpm klawty start${NC}"
    fi
}

# ── Summary ───────────────────────────────────────────────────────────────────
print_summary() {
    divider
    printf "  ${GREEN}${BOLD}Onboarding complete!${NC}\n\n"

    printf "  ${BOLD}Configuration Summary${NC}\n"
    printf "  ${DIM}─────────────────────────────────────────${NC}\n"
    printf "  ${BOLD}Industry:${NC}     %s\n" "${INDUSTRY}"
    printf "  ${BOLD}Channel:${NC}      %s\n" "${CHANNEL}"
    printf "  ${BOLD}LLM:${NC}          OpenRouter\n"
    printf "  ${BOLD}Memory:${NC}       Qdrant @ ${QDRANT_URL}\n"
    if [[ "${DEV_MODE}" == true ]]; then
        printf "  ${BOLD}License:${NC}      ${YELLOW}dev mode${NC}\n"
    else
        printf "  ${BOLD}License:${NC}      ${GREEN}activated${NC}\n"
    fi
    printf "\n"
    printf "  ${BOLD}Files written:${NC}\n"
    printf "    ${CHECK} .env\n"
    printf "    ${CHECK} klawty.json\n"
    printf "\n"
    printf "  ${BOLD}Useful commands:${NC}\n"
    printf "    ${ARROW} ${CYAN}klawty start${NC}       Start all agents\n"
    printf "    ${ARROW} ${CYAN}klawty status${NC}      Check agent health\n"
    printf "    ${ARROW} ${CYAN}klawty logs${NC}        Tail agent logs\n"
    printf "    ${ARROW} ${CYAN}klawty stop${NC}        Stop all agents\n"
    printf "\n"
    printf "  ${BOLD}Documentation:${NC}  ${BLUE}https://docs.klawty.ai${NC}\n"
    printf "  ${BOLD}Support:${NC}        ${BLUE}https://klawty.ai/support${NC}\n"
    printf "\n"
}

# ── Main ──────────────────────────────────────────────────────────────────────
main() {
    banner
    step_license
    step_llm
    step_industry
    step_channel
    step_docker
    step_write_env
    step_write_config
    step_activate
    step_start
    print_summary
}

main "$@"
