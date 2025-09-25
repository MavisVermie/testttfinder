# Firebase Authentication Setup

This app now includes Firebase Authentication with email/password and Google sign-in support.

## Setup Instructions

### 1. Create a Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Create a project" or "Add project"
3. Enter project name: `ai-tourist-guide` (or your preferred name)
4. Follow the setup wizard

### 2. Enable Authentication

1. In your Firebase project, go to "Authentication" in the left sidebar
2. Click "Get started"
3. Go to "Sign-in method" tab
4. Enable "Email/Password" authentication
5. Enable "Google" authentication and configure it

### 3. Add Your App to Firebase

#### For Android:
1. Click "Add app" and select Android
2. Enter package name: `com.example.ui_pathfinder1`
3. Download the `google-services.json` file
4. Replace the existing `android/app/google-services.json` with your downloaded file

#### For iOS:
1. Click "Add app" and select iOS
2. Enter bundle ID: `com.example.uiPathfinder1`
3. Download the `GoogleService-Info.plist` file
4. Replace the existing `ios/Runner/GoogleService-Info.plist` with your downloaded file

### 4. Configure Google Sign-In

#### For Android:
1. In Firebase Console, go to Project Settings > General
2. Add your SHA-1 fingerprint:
   - Run: `keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android`
   - Copy the SHA-1 fingerprint and add it to your Firebase project

#### For iOS:
1. In Firebase Console, go to Project Settings > General
2. Add your iOS bundle ID: `com.example.uiPathfinder1`

### 5. Test the App

1. Run `flutter pub get` to install dependencies
2. Run `flutter run` to start the app
3. Test both email/password and Google sign-in flows

## Features Implemented

- ✅ Email/Password Authentication
- ✅ Google Sign-In
- ✅ User Profile Management
- ✅ Sign Out Functionality
- ✅ Authentication State Management
- ✅ Error Handling with User-Friendly Messages

## Troubleshooting

- Make sure your Firebase project has the correct package name/bundle ID
- Ensure Google Sign-In is properly configured with SHA-1 fingerprints
- Check that the configuration files are in the correct locations
- Verify that Authentication methods are enabled in Firebase Console

## Security Notes

- The current configuration files contain dummy data for development
- Replace them with your actual Firebase configuration before production
- Never commit real Firebase configuration files to public repositories
