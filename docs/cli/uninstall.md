---
summary: "CLI reference for `klawty uninstall` (remove gateway service + local data)"
read_when:
  - You want to remove the gateway service and/or local state
  - You want a dry-run first
title: "uninstall"
---

# `klawty uninstall`

Uninstall the gateway service + local data (CLI remains).

```bash
klawty backup create
klawty uninstall
klawty uninstall --all --yes
klawty uninstall --dry-run
```

Run `klawty backup create` first if you want a restorable snapshot before removing state or workspaces.
