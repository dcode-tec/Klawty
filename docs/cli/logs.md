---
summary: "CLI reference for `klawty logs` (tail gateway logs via RPC)"
read_when:
  - You need to tail Gateway logs remotely (without SSH)
  - You want JSON log lines for tooling
title: "logs"
---

# `klawty logs`

Tail Gateway file logs over RPC (works in remote mode).

Related:

- Logging overview: [Logging](/logging)

## Examples

```bash
klawty logs
klawty logs --follow
klawty logs --json
klawty logs --limit 500
klawty logs --local-time
klawty logs --follow --local-time
```

Use `--local-time` to render timestamps in your local timezone.
