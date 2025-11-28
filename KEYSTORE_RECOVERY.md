# 🔑 Keystore Recovery Guide

**⚠️ TEMPORARY DOCUMENTATION - DELETE AFTER RECOVERY ⚠️**

This guide helps you retrieve your Android keystore from GitHub Actions secrets and generate SHA values for Firebase.

## Quick Steps

### Option 1: Using GitHub Actions Workflow (Recommended)

1. **Push the temporary workflow** (already created at `.github/workflows/temp-get-keystore.yml`)

2. **Run the workflow manually:**
   - Go to GitHub → Actions tab
   - Select "🔓 Temporary - Get Keystore Base64" workflow
   - Click "Run workflow" → Run workflow
   - Wait for it to complete

3. **Copy the base64 string** from the workflow output logs

4. **Decode and save locally:**
   ```bash
   echo '<paste_base64_string_here>' | base64 --decode > android/key.jks
   ```

5. **Set the password:**
   ```bash
   export ANDROID_KEYSTORE_PASSWORD='your_keystore_password'
   ```
   (Get the password from GitHub Secrets: `ANDROID_KEYSTORE_PASSWORD`)

6. **Generate SHA values:**
   ```bash
   ./scripts/get-keystore-sha.sh
   ```

7. **Add SHA values to Firebase:**
   - Go to Firebase Console → Project Settings → Your Android App
   - Click "Add fingerprint"
   - Paste the SHA-1 and SHA-256 values

8. **Clean up:**
   - Delete `.github/workflows/temp-get-keystore.yml`
   - Delete this file (`KEYSTORE_RECOVERY.md`)

### Option 2: Using Scripts Directly

If you already have the base64 string:

```bash
# Decode keystore
./scripts/decode-keystore.sh '<base64_string>'

# Set password
export ANDROID_KEYSTORE_PASSWORD='your_password'

# Generate SHA values
./scripts/get-keystore-sha.sh
```

## Manual Method

If you prefer to do it manually:

```bash
# 1. Decode keystore
echo '<base64_string>' | base64 --decode > android/key.jks

# 2. Generate SHA-1
keytool -list -v -keystore android/key.jks -alias release \
  -storepass '<password>' -keypass '<password>' | grep SHA1

# 3. Generate SHA-256
keytool -list -v -keystore android/key.jks -alias release \
  -storepass '<password>' -keypass '<password>' | grep SHA256
```

## Keystore Details

- **File location:** `android/key.jks`
- **Key alias:** `release`
- **Password:** Stored in GitHub Secret `ANDROID_KEYSTORE_PASSWORD`
- **Base64 secret:** Stored in GitHub Secret `ANDROID_KEYSTORE_FILE_BASE64`

## Security Note

⚠️ **IMPORTANT:** After recovering your keystore:
- Keep `android/key.jks` secure and never commit it to git
- Delete the temporary workflow file
- Consider backing up the keystore securely (encrypted, off-site)

