# Google Maps Setup Guide

## Prerequisites
1. Google Cloud Platform account
2. Google Maps API enabled

## Setup Steps

### 1. Get Google Maps API Key
1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project or select existing one
3. Enable the following APIs:
   - Maps SDK for Android
   - Places API
   - Directions API
   - Distance Matrix API
4. Go to "Credentials" and create an API key
5. Restrict the API key to your app's package name

### 2. Configure Android
1. Open `android/app/src/main/AndroidManifest.xml`
2. Replace `YOUR_GOOGLE_MAPS_API_KEY_HERE` with your actual API key:
   ```xml
   <meta-data
       android:name="com.google.android.geo.API_KEY"
       android:value="YOUR_ACTUAL_API_KEY_HERE" />
   ```

### 3. Configure iOS (if needed)
1. Open `ios/Runner/AppDelegate.swift`
2. Add the following import:
   ```swift
   import GoogleMaps
   ```
3. In the `application` method, add:
   ```swift
   GMSServices.provideAPIKey("YOUR_ACTUAL_API_KEY_HERE")
   ```

### 4. Backend Configuration
1. Set the `GOOGLE_MAPS_API_KEY` environment variable in your backend
2. Make sure the backend has access to the same APIs

## Testing
1. Run `flutter pub get` to install dependencies
2. Run the app and navigate to the Transportation screen
3. Grant location permissions when prompted
4. The map should load with your current location and nearby transportation options

## Troubleshooting
- If the map doesn't load, check that the API key is correctly set
- If location doesn't work, ensure location permissions are granted
- If transportation data doesn't load, check that the backend is running and accessible
