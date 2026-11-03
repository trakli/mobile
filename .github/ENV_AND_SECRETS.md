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

The Fastfile merges JSON objects per environment and passes them to
`flutter build` with `--dart-define-from-file`, so values never appear in the
build command fastlane logs. Public values go in **Variables**; sensitive values
go in **Secrets**. Adding a new build-time parameter is a JSON key — no workflow
or Fastfile change. Values must be strings, numbers or booleans.

| Name | Type | Used by | Description |
|------|------|---------|-------------|
| `DART_DEFINES_PROD` | Variable | release (prod) lanes | JSON object of `--dart-define` key/value pairs for production. |
| `DART_DEFINES_STAGING` | Variable | staging/dev lanes | JSON object of `--dart-define` key/value pairs for staging and dev builds. |
| `DART_DEFINES` | Variable | all lanes | Shared fallback when the per-environment variable is unset. |
| `DART_DEFINES_PROD_SECRETS` | Secret | release (prod) lanes | Secret `--dart-define` values for production; merged last, wins on key clash. |
| `DART_DEFINES_STAGING_SECRETS` | Secret | staging/dev lanes | Secret `--dart-define` values for staging/dev; merged last. |

Example `DART_DEFINES_PROD` value:

```json
{
  "REVERB_APP_KEY": "<production Reverb app key>",
  "REVERB_HOST": "reverb.trakli.app",
  "REVERB_PORT": "443",
  "REVERB_SCHEME": "https"
}
```

`DART_DEFINES_STAGING` is the same shape with the staging Reverb values
(`reverb.dev.trakli.app`). Secret values use the same JSON shape, e.g.
`DART_DEFINES_PROD_SECRETS` = `{"SENTRY_DSN": "…", "MAPS_API_KEY": "…"}`.

The Fastfile merges them with precedence **per-env Secrets → per-env Variables
→ shared `DART_DEFINES`**, and logs the key names (never the values) it passes.
If all are unset, nothing is passed and the app uses its built-in defaults:
without `REVERB_APP_KEY`, AI chat updates by polling only.

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
- `DART_DEFINES_PROD_SECRETS`, `DART_DEFINES_STAGING_SECRETS` (optional JSON)

**Variables (Actions → Variables):**

- `APP_BUNDLE_ID` (e.g. `com.whilesmart.trakli`)
- `APP_PACKAGE_NAME` (e.g. `com.whilesmart.trakli`)
- `DART_DEFINES_PROD`, `DART_DEFINES_STAGING` (optional JSON; `DART_DEFINES` fallback)

**Certificates repo:** Ensure the repo used by Match (default: `git@github.com:whilesmart/certificates.git`) exists and that the deploy key has access. Run **iOS Certificate Setup** (ios-setup.yml) once via workflow_dispatch to generate/update certs and profiles for `com.whilesmart.trakli`, `com.whilesmart.trakli.dev`, and `com.whilesmart.trakli.stg`. Staging uses bundle ID `com.whilesmart.trakli.stg`; no extra secrets beyond MATCH/ASC_*.
