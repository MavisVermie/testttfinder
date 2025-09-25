# Google Sign-In Troubleshooting Guide

## Common Issues and Solutions

### 1. **SHA-1 Fingerprint Missing** (Most Common)
This is the #1 cause of Google Sign-In failures.

**To get your SHA-1 fingerprint:**
```bash
# Method 1: Using keytool (if Java is in PATH)
keytool -list -v -keystore %USERPROFILE%\.android\debug.keystore -alias androiddebugkey -storepass android -keypass android

# Method 2: Using Android Studio
# 1. Open Android Studio
# 2. Go to Gradle tab (right side)
# 3. Navigate to: app → Tasks → android → signingReport
# 4. Double-click signingReport
# 5. Copy the SHA1 fingerprint from the output

# Method 3: Using Flutter
flutter build apk --debug
# Then check the build output for SHA-1
```

**To add SHA-1 to Firebase:**
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project: `pathfinder-ai-472811`
3. Go to **Project Settings** (gear icon)
4. Scroll down to **Your apps** section
5. Click on your Android app
6. Add the SHA-1 fingerprint
7. Download the updated `google-services.json`
8. Replace the file in `android/app/google-services.json`

### 2. **Google Sign-In Not Enabled**
1. Go to Firebase Console → **Authentication** → **Sign-in method**
2. Click on **Google**
3. Toggle **Enable**
4. Add your **Project support email**
5. Click **Save**

### 3. **Package Name Mismatch**
Verify these match exactly:
- Your app: `com.example.ui_pathfinder1`
- Firebase Console Android app package name
- `android/app/build.gradle.kts` applicationId

### 4. **OAuth Client Configuration**
Make sure you have the correct OAuth client in Firebase Console:
1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Select your project: `pathfinder-ai-472811`
3. Go to **APIs & Services** → **Credentials**
4. Check that you have an OAuth 2.0 client for Android
5. Verify the package name and SHA-1 fingerprint

### 5. **Testing Steps**
1. Run the app: `flutter run`
2. Try Google Sign-In
3. Check the console output for error messages
4. Look for specific error codes in the logs

### 6. **Debug Information**
The app now includes detailed logging. Check the console output for:
- "Starting Google Sign-In..."
- "Google user obtained: [email]"
- "Google auth tokens obtained"
- "Firebase credential created"
- "Firebase sign-in successful: [email]"

### 7. **Common Error Messages**
- **"DEVELOPER_ERROR"**: Usually SHA-1 fingerprint issue
- **"NETWORK_ERROR"**: Check internet connection
- **"SIGN_IN_FAILED"**: Check OAuth client configuration
- **"INVALID_CREDENTIAL"**: Check Firebase configuration

### 8. **Quick Fix Checklist**
- [ ] SHA-1 fingerprint added to Firebase Console
- [ ] Google Sign-In enabled in Firebase Console
- [ ] Package name matches exactly
- [ ] `google-services.json` is up to date
- [ ] Project support email is set
- [ ] OAuth client is configured correctly

### 9. **Alternative: Get SHA-1 from Android Studio**
1. Open Android Studio
2. Open your project
3. Go to **Build** → **Generate Signed Bundle/APK**
4. Choose **APK**
5. Click **Create new...**
6. Fill in the keystore details
7. The SHA-1 will be shown in the keystore creation dialog

### 10. **If Still Not Working**
1. Check the console output for specific error messages
2. Verify all configuration steps above
3. Try creating a new Firebase project
4. Make sure you're testing on a real device (not emulator for some cases)
