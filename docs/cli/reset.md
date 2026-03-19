---
summary: "CLI reference for `klawty reset` (reset local state/config)"
read_when:
  - You want to wipe local state while keeping the CLI installed
  - You want a dry-run of what would be removed
title: "reset"
---

# `klawty reset`

Reset local config/state (keeps the CLI installed).

```bash
klawty backup create
klawty reset
klawty reset --dry-run
klawty reset --scope config+creds+sessions --yes --non-interactive
```

Run `klawty backup create` first if you want a restorable snapshot before removing local state.
