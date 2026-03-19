---
summary: "CLI reference for `klawty voicecall` (voice-call plugin command surface)"
read_when:
  - You use the voice-call plugin and want the CLI entry points
  - You want quick examples for `voicecall call|continue|status|tail|expose`
title: "voicecall"
---

# `klawty voicecall`

`voicecall` is a plugin-provided command. It only appears if the voice-call plugin is installed and enabled.

Primary doc:

- Voice-call plugin: [Voice Call](/plugins/voice-call)

## Common commands

```bash
klawty voicecall status --call-id <id>
klawty voicecall call --to "+15555550123" --message "Hello" --mode notify
klawty voicecall continue --call-id <id> --message "Any questions?"
klawty voicecall end --call-id <id>
```

## Exposing webhooks (Tailscale)

```bash
klawty voicecall expose --mode serve
klawty voicecall expose --mode funnel
klawty voicecall expose --mode off
```

Security note: only expose the webhook endpoint to networks you trust. Prefer Tailscale Serve over Funnel when possible.
