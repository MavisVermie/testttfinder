# Google Cloud Text-to-Speech Setup Guide

## Quick Setup (Required for Text-to-Speech)

The translation is working, but Text-to-Speech requires Google Cloud credentials. Here's how to set it up:

### Option 1: Service Account Key (Recommended)

1. **Go to Google Cloud Console**: https://console.cloud.google.com/
2. **Create a new project** or select existing one
3. **Enable Text-to-Speech API**:
   - Go to "APIs & Services" > "Library"
   - Search for "Text-to-Speech API"
   - Click "Enable"
4. **Create Service Account**:
   - Go to "IAM & Admin" > "Service Accounts"
   - Click "Create Service Account"
   - Name: `tts-service`
   - Description: `Text-to-Speech service account`
   - Click "Create and Continue"
   - Role: `Text-to-Speech Client` (or `Editor` for full access)
   - Click "Done"
5. **Create Key**:
   - Click on your service account
   - Go to "Keys" tab
   - Click "Add Key" > "Create new key"
   - Choose "JSON" format
   - Download the JSON file
6. **Set Environment Variable**:
   - Copy the JSON file to your project folder
   - Rename it to `google-credentials.json`
   - Add to your `.env` file:
     ```
     GOOGLE_APPLICATION_CREDENTIALS=./google-credentials.json
     ```

### Option 2: Application Default Credentials

1. **Install Google Cloud CLI**: https://cloud.google.com/sdk/docs/install
2. **Authenticate**:
   ```bash
   gcloud auth application-default login
   ```
3. **Set Project**:
   ```bash
   gcloud config set project YOUR_PROJECT_ID
   ```

### Option 3: Disable Text-to-Speech (Temporary)

If you don't need TTS right now, the translation will still work. The server will just show warnings instead of crashing.

## Testing

1. **Restart your server**: `npm start`
2. **Check the logs** - you should see "Text-to-Speech service not available" warnings instead of crashes
3. **Test translation** - it should work without audio
4. **Test TTS** - it will show a warning but won't crash

## Current Status

✅ **Translation**: Working perfectly  
⚠️ **Text-to-Speech**: Needs Google Cloud setup  
✅ **Server**: Won't crash anymore  

## Next Steps

1. Set up Google Cloud credentials (Option 1 above)
2. Restart the server
3. Test the complete translation + TTS pipeline

The translation feature is fully functional - you just need to add TTS credentials to enable the speech features!
