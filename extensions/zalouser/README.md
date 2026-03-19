# @klawty/zalouser

Klawty extension for Zalo Personal Account messaging via native `zca-js` integration.

> **Warning:** Using Zalo automation may result in account suspension or ban. Use at your own risk. This is an unofficial integration.

## Features

- Channel plugin integration with setup wizard + QR login
- In-process listener/sender via `zca-js` (no external CLI)
- Multi-account support
- Agent tool integration (`zalouser`)
- DM/group policy support

## Prerequisites

- Klawty Gateway
- Zalo mobile app (for QR login)

No external `zca`, `openzca`, or `zca-cli` binary is required.

## Install

### Option A: npm

```bash
klawty plugins install @klawty/zalouser
```

### Option B: local source checkout

```bash
klawty plugins install ./extensions/zalouser
cd ./extensions/zalouser && pnpm install
```

Restart the Gateway after install.

## Quick start

### Login (QR)

```bash
klawty channels login --channel zalouser
```

Scan the QR code with the Zalo app on your phone.

### Enable channel

```yaml
channels:
  zalouser:
    enabled: true
    dmPolicy: pairing # pairing | allowlist | open | disabled
```

### Send a message

```bash
klawty message send --channel zalouser --target <threadId> --message "Hello from Klawty"
```

## Configuration

Basic:

```yaml
channels:
  zalouser:
    enabled: true
    dmPolicy: pairing
```

Multi-account:

```yaml
channels:
  zalouser:
    enabled: true
    defaultAccount: default
    accounts:
      default:
        enabled: true
        profile: default
      work:
        enabled: true
        profile: work
```

## Useful commands

```bash
klawty channels login --channel zalouser
klawty channels login --channel zalouser --account work
klawty channels status --probe
klawty channels logout --channel zalouser

klawty directory self --channel zalouser
klawty directory peers list --channel zalouser --query "name"
klawty directory groups list --channel zalouser --query "work"
klawty directory groups members --channel zalouser --group-id <id>
```

## Agent tool

The extension registers a `zalouser` tool for AI agents.

Available actions: `send`, `image`, `link`, `friends`, `groups`, `me`, `status`

## Troubleshooting

- Login not persisted: `klawty channels logout --channel zalouser && klawty channels login --channel zalouser`
- Probe status: `klawty channels status --probe`
- Name resolution issues (allowlist/groups): use numeric IDs or exact Zalo names

## Credits

Built on [zca-js](https://github.com/RFS-ADRENO/zca-js).
