# MiniMax (Klawty plugin)

Bundled MiniMax plugin for both:

- API-key provider setup (`minimax`)
- Coding Plan OAuth setup (`minimax-portal`)

## Enable

```bash
klawty plugins enable minimax
```

Restart the Gateway after enabling.

```bash
klawty gateway restart
```

## Authenticate

OAuth:

```bash
klawty models auth login --provider minimax-portal --set-default
```

API key:

```bash
klawty setup --wizard --auth-choice minimax-global-api
```

## Notes

- MiniMax OAuth uses a user-code login flow.
- OAuth currently targets the Coding Plan path.
