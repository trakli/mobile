# Local build-time values (`--dart-define`)

Every VS Code launch config passes `--dart-define-from-file
dart_defines/<flavor>.json`, so these values reach the app through
`String.fromEnvironment(...)` exactly as they do in CI.

`*.json` here is **gitignored** — it holds credentials. Only `*.example.json`
is tracked. Before your first run:

```bash
for f in development staging production; do
  cp dart_defines/$f.example.json dart_defines/$f.json
done
# then fill in REVERB_APP_KEY in each
```

| Flavor | API | Reverb |
|---|---|---|
| `development` | `api.dev.trakli.app` | `wss://reverb.dev.trakli.app` |
| `staging` | `api.dev.trakli.app` | `wss://reverb.dev.trakli.app` |
| `production` | `api.trakli.app` | `wss://reverb.trakli.app` |

`development` and `staging` both run against the dev API, so they share the
same Reverb app key.

Leave `REVERB_APP_KEY` empty and the AI chat socket stays off, so chat updates
by polling only — everything else still works. The CI equivalents are the
`STG_REVERB_*` / `PROD_REVERB_*` repo settings documented in
[../.github/ENV_AND_SECRETS.md](../.github/ENV_AND_SECRETS.md).
