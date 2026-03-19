---
summary: "Uninstall Klawty completely (CLI, service, state, workspace)"
read_when:
  - You want to remove Klawty from a machine
  - The gateway service is still running after uninstall
title: "Uninstall"
---

# Uninstall

Two paths:

- **Easy path** if `klawty` is still installed.
- **Manual service removal** if the CLI is gone but the service is still running.

## Easy path (CLI still installed)

Recommended: use the built-in uninstaller:

```bash
klawty uninstall
```

Non-interactive (automation / npx):

```bash
klawty uninstall --all --yes --non-interactive
npx -y klawty uninstall --all --yes --non-interactive
```

Manual steps (same result):

1. Stop the gateway service:

```bash
klawty gateway stop
```

2. Uninstall the gateway service (launchd/systemd/schtasks):

```bash
klawty gateway uninstall
```

3. Delete state + config:

```bash
rm -rf "${KLAWTY_STATE_DIR:-$HOME/.klawty}"
```

If you set `KLAWTY_CONFIG_PATH` to a custom location outside the state dir, delete that file too.

4. Delete your workspace (optional, removes agent files):

```bash
rm -rf ~/.klawty/workspace
```

5. Remove the CLI install (pick the one you used):

```bash
npm rm -g klawty
pnpm remove -g klawty
bun remove -g klawty
```

6. If you installed the macOS app:

```bash
rm -rf /Applications/Klawty.app
```

Notes:

- If you used profiles (`--profile` / `KLAWTY_PROFILE`), repeat step 3 for each state dir (defaults are `~/.klawty-<profile>`).
- In remote mode, the state dir lives on the **gateway host**, so run steps 1-4 there too.

## Manual service removal (CLI not installed)

Use this if the gateway service keeps running but `klawty` is missing.

### macOS (launchd)

Default label is `ai.klawty.gateway` (or `ai.klawty.<profile>`; legacy `com.klawty.*` may still exist):

```bash
launchctl bootout gui/$UID/ai.klawty.gateway
rm -f ~/Library/LaunchAgents/ai.klawty.gateway.plist
```

If you used a profile, replace the label and plist name with `ai.klawty.<profile>`. Remove any legacy `com.klawty.*` plists if present.

### Linux (systemd user unit)

Default unit name is `klawty-gateway.service` (or `klawty-gateway-<profile>.service`):

```bash
systemctl --user disable --now klawty-gateway.service
rm -f ~/.config/systemd/user/klawty-gateway.service
systemctl --user daemon-reload
```

### Windows (Scheduled Task)

Default task name is `Klawty Gateway` (or `Klawty Gateway (<profile>)`).
The task script lives under your state dir.

```powershell
schtasks /Delete /F /TN "Klawty Gateway"
Remove-Item -Force "$env:USERPROFILE\.klawty\gateway.cmd"
```

If you used a profile, delete the matching task name and `~\.klawty-<profile>\gateway.cmd`.

## Normal install vs source checkout

### Normal install (install.sh / npm / pnpm / bun)

If you used `https://klawty.ai/install.sh` or `install.ps1`, the CLI was installed with `npm install -g klawty@latest`.
Remove it with `npm rm -g klawty` (or `pnpm remove -g` / `bun remove -g` if you installed that way).

### Source checkout (git clone)

If you run from a repo checkout (`git clone` + `klawty ...` / `bun run klawty ...`):

1. Uninstall the gateway service **before** deleting the repo (use the easy path above or manual service removal).
2. Delete the repo directory.
3. Remove state + workspace as shown above.
