# GitHub Actions: Secrets and Variables neccessary for faslane deployment

Configure these in your repo: **Settings → Secrets and variables → Actions**.

Use **Secrets** for sensitive values; use **Variables** for non-sensitive identifiers.

---

## iOS (Match + App Store Connect)

| Name | Type | Used by | Description |
|------|------|---------|-------------|
| `MATCH_DEPLOY_KEY` | Secret | deploy-with-fastlane, ios-setup, ios-release | Private SSH key that has read (and for setup, write) access to the certificates repo. Used by `webfactory/ssh-agent`. |
| `MATCH_PASSWORD` | Secret | deploy-with-fastlane, ios-setup, ios-release | Password for the Match-encrypted certs/profiles in the repo. |
| `ASC_KEY_ID` | Secret | deploy-with-fastlane, ios-setup, ios-release | App Store Connect API key ID. |
| `ASC_ISSUER_ID` | Secret | deploy-with-fastlane, ios-setup, ios-release | App Store Connect issuer ID. |
| `ASC_KEY_P8_BASE64` | Secret | deploy-with-fastlane, ios-setup, ios-release | App Store Connect API private key (.p8) content, **base64-encoded**. |
| `APP_BUNDLE_ID` | Variable | deploy-with-fastlane, ios-release (prod) | Production iOS bundle ID, e.g. `com.whilesmart.trakli`. |
| `CREDENTIAL_FILE_CONTENT` | Secret | ios-setup, ios-release | Same as Android: Firebase/service account JSON **raw string**. Written to `service_credentials_content.json` for iOS lanes (e.g. release_firebase, Crashlytics). |
| `FIREBASE_APP_ID` | Secret | ios-release (firebase track), android-release (firebase) | Firebase app ID. For iOS dev distribution use this, or set `FIREBASE_APP_ID_IOS_DEV` for the iOS dev app. |
| `FIREBASE_APP_ID_IOS_DEV` | Secret | ios-release (firebase track) | Optional. iOS dev Firebase app ID for App Distribution. If unset, `release_firebase` falls back to `FIREBASE_APP_ID`. |

**Optional (only if you use a different cert repo):**

| Name | Type | Description |
|------|------|-------------|
| `MATCH_GIT_URL` | Secret or Variable | Git URL for the Match repo, e.g. `git@github.com:whilesmart/certificates.git`. Default in Matchfile is `git@github.com:whilesmart/certificates.git`. |

---

## Android

| Name | Type | Used by | Description |
|------|------|---------|-------------|
| `GOOGLE_SERVICES_ACCOUNT_BASE64` | Secret | deploy-with-fastlane, android-release | Google Play service account JSON, **base64-encoded**. Decoded to `google_service_account.json` in repo root. |
| `CREDENTIAL_FILE_CONTENT` | Secret | deploy-with-fastlane, android-release, ios-setup, ios-release | Firebase / Google service account JSON **raw string** for distribution. Written to `service_credentials_content.json`. |
| `ANDROID_KEYSTORE_FILE_BASE64` | Secret | deploy-with-fastlane | Release keystore (.jks) file content, **base64-encoded**. |
| `ANDROID_KEYSTORE_PASSWORD` | Secret | deploy-with-fastlane | Keystore and key password. |
| `APP_PACKAGE_NAME` | Variable | deploy-with-fastlane, android-release | Android applicationId, e.g. `com.whilesmart.trakli`. |
| `FIREBASE_APP_ID` | Secret | android-release (firebase track) | Firebase Android app ID (for App Distribution). |

---

## Build-time parameters (`--dart-define`)

Any environment variable named `DART_DEFINE_<NAME>` on the fastlane step is
passed to `flutter build` as the dart-define `<NAME>`, which the app reads with
`String.fromEnvironment('<NAME>')`. The Fastfile writes them to a temporary
`--dart-define-from-file` JSON file, so values never appear in the build
command fastlane logs; it logs the names only and deletes the file after the
build. Empty values are skipped, so an unset variable leaves the app's default.

The workflows map repo settings to those names. Each workflow builds a single
environment, so it uses one prefix: `release.yaml` and
`deploy-with-fastlane.yaml` read `PROD_*`, `staging-distribute.yml` reads
`STG_*`.

| Name | Type | Used by | Description |
|------|------|---------|-------------|
| `PROD_REVERB_APP_KEY` / `STG_REVERB_APP_KEY` | Secret | prod / staging builds | Reverb app key. Without it the AI chat socket stays off and chat updates by polling only. |
| `PROD_REVERB_HOST` / `STG_REVERB_HOST` | Variable | prod / staging builds | Reverb server: `reverb.trakli.app` / `reverb.dev.trakli.app`. A full URL such as `wss://reverb.trakli.app` also works. Defaults to the API host. |
| `PROD_REVERB_PORT` / `STG_REVERB_PORT` | Variable | prod / staging builds | Optional. Defaults to 443 (80 when the scheme is `http`/`ws`). |
| `PROD_REVERB_SCHEME` / `STG_REVERB_SCHEME` | Variable | prod / staging builds | Optional. `https` (default, TLS) or `http`. |

Plain values are mapped once at the top of each workflow:

```yaml
env:
  DART_DEFINE_REVERB_HOST: ${{ vars.PROD_REVERB_HOST }}
```

Secrets are mapped on the fastlane step only, so no other action in the job
receives them:

```yaml
- name: Release to Play Store
  run: bundle exec fastlane release_play_store
  env:
    DART_DEFINE_REVERB_APP_KEY: ${{ secrets.PROD_REVERB_APP_KEY }}
```

**Adding a build-time value** needs no Fastfile change: create the variable or
secret, add its `DART_DEFINE_<NAME>` line to the workflows that need it, and
read `String.fromEnvironment('<NAME>')` in the app. Values compiled into the
app can be read by anyone who unpacks it, so this suits keys that are meant to
ship in the client (like the Reverb app key), not server credentials.

For a local fastlane build, export the same names first, e.g.
`DART_DEFINE_REVERB_APP_KEY=… bundle exec fastlane …`.

---

## Summary checklist

**Secrets (Actions → Secrets):**

- `MATCH_DEPLOY_KEY`
- `MATCH_PASSWORD`
- `ASC_KEY_ID`
- `ASC_ISSUER_ID`
- `ASC_KEY_P8_BASE64`
- `GOOGLE_SERVICES_ACCOUNT_BASE64`
- `CREDENTIAL_FILE_CONTENT`
- `ANDROID_KEYSTORE_FILE_BASE64`
- `ANDROID_KEYSTORE_PASSWORD`
- `FIREBASE_APP_ID` (if using Android or iOS Firebase App Distribution)
- `FIREBASE_APP_ID_IOS_DEV` (optional; for iOS dev Firebase track; falls back to `FIREBASE_APP_ID`)
- `PROD_REVERB_APP_KEY`, `STG_REVERB_APP_KEY`

**Variables (Actions → Variables):**

- `APP_BUNDLE_ID` (e.g. `com.whilesmart.trakli`)
- `APP_PACKAGE_NAME` (e.g. `com.whilesmart.trakli`)
- `PROD_REVERB_HOST`, `STG_REVERB_HOST` (optional: `*_REVERB_PORT`, `*_REVERB_SCHEME`)

**Certificates repo:** Ensure the repo used by Match (default: `git@github.com:whilesmart/certificates.git`) exists and that the deploy key has access. Run **iOS Certificate Setup** (ios-setup.yml) once via workflow_dispatch to generate/update certs and profiles for `com.whilesmart.trakli`, `com.whilesmart.trakli.dev`, and `com.whilesmart.trakli.stg`. Staging uses bundle ID `com.whilesmart.trakli.stg`; no extra secrets beyond MATCH/ASC_*.
