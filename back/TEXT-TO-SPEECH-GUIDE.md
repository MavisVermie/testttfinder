# Text-to-Speech Integration Guide

This guide explains how to use the new Google Text-to-Speech integration with your AI Travel Assistant API.

## Overview

The Text-to-Speech (TTS) integration allows you to:
- Convert any text to natural-sounding speech
- Translate text and convert the translation to speech
- Complete audio pipeline: audio input → transcription → translation → speech output
- Support multiple languages and voice options
- Generate audio in various formats (MP3, WAV, OGG, FLAC)

## Setup

### 1. Google Cloud Setup

1. **Enable Text-to-Speech API**:
   - Go to [Google Cloud Console](https://console.cloud.google.com/)
   - Navigate to "APIs & Services" > "Library"
   - Search for "Text-to-Speech API" and enable it

2. **Set up Authentication**:
   - Create a service account or use existing one
   - Download the service account key JSON file
   - Set the `GOOGLE_APPLICATION_CREDENTIALS` environment variable to the path of your JSON file

### 2. Environment Variables

Add to your `.env` file:
```env
# Google Text-to-Speech (uses same credentials as Speech-to-Text)
GOOGLE_APPLICATION_CREDENTIALS=path/to/your/service-account.json
```

## API Endpoints

### 1. Text-to-Speech

**POST** `/api/translation/text-to-speech`

Convert text directly to speech.

**Request Body:**
```json
{
  "text": "Hello, this is a test!",
  "languageCode": "en-US",
  "voiceName": "en-US-Wavenet-D",
  "audioFormat": "mp3",
  "speakingRate": 1.0,
  "pitch": 0.0,
  "volumeGainDb": 0.0,
  "ssmlGender": "NEUTRAL"
}
```

**Response:** Audio file (binary)

**Parameters:**
- `text` (required): Text to convert to speech
- `languageCode` (optional): Language code (default: "en-US")
- `voiceName` (optional): Specific voice name
- `audioFormat` (optional): "mp3", "wav", "ogg", "flac" (default: "mp3")
- `speakingRate` (optional): 0.25 to 4.0 (default: 1.0)
- `pitch` (optional): -20.0 to 20.0 (default: 0.0)
- `volumeGainDb` (optional): -96.0 to 16.0 (default: 0.0)
- `ssmlGender` (optional): "NEUTRAL", "FEMALE", "MALE" (default: "NEUTRAL")

### 2. Translate and Speak

**POST** `/api/translation/translate-and-speak`

Translate text and convert the translation to speech.

**Request Body:**
```json
{
  "message": "Hello, how are you?",
  "chatflowId": "your-chatflow-id",
  "sourceLanguage": "en",
  "targetLanguage": "es",
  "audioFormat": "mp3",
  "includeAudioInResponse": true
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "originalText": "Hello, how are you?",
    "translatedText": "Hola, ¿cómo estás?",
    "sourceLanguage": "en",
    "targetLanguage": "es",
    "audio": {
      "format": "mp3",
      "size": 12345,
      "languageCode": "es-ES",
      "voiceName": "es-ES-Wavenet-B"
    },
    "audioContent": "base64-encoded-audio-data"
  }
}
```

### 3. Audio Translate Speak

**POST** `/api/translation/audio-translate-speak`

Complete audio pipeline: audio input → transcription → translation → speech output.

**Form Data:**
- `file`: Audio file (required)
- `chatflowId`: Flowise chatflow ID
- `sourceLanguage`: Source language (default: "auto")
- `targetLanguage`: Target language (default: "auto")
- `audioFormat`: Output audio format (default: "mp3")
- `includeAudioInResponse`: Include audio in JSON response (default: false)

**Response:** Similar to translate-and-speak but includes original transcribed text.

### 4. Get Voices

**GET** `/api/translation/voices?languageCode=en-US`

Get available voices for a specific language.

**Response:**
```json
{
  "success": true,
  "data": {
    "voices": [
      {
        "name": "en-US-Wavenet-A",
        "ssmlGender": "FEMALE",
        "naturalSampleRateHertz": 24000
      }
    ],
    "languageCode": "en-US"
  }
}
```

### 5. Get TTS Languages

**GET** `/api/translation/tts-languages`

Get supported languages and their default voices.

**Response:**
```json
{
  "success": true,
  "data": {
    "languages": [
      {
        "code": "en",
        "languageCode": "en-US",
        "defaultVoice": "en-US-Wavenet-D",
        "name": "English"
      }
    ],
    "audioFormats": ["mp3", "wav", "ogg", "flac"]
  }
}
```

## Supported Languages

The TTS service supports 14+ languages with high-quality WaveNet voices:

- **English** (en-US): en-US-Wavenet-D
- **Spanish** (es-ES): es-ES-Wavenet-B
- **French** (fr-FR): fr-FR-Wavenet-A
- **German** (de-DE): de-DE-Wavenet-A
- **Italian** (it-IT): it-IT-Wavenet-A
- **Portuguese** (pt-PT): pt-PT-Wavenet-A
- **Russian** (ru-RU): ru-RU-Wavenet-A
- **Japanese** (ja-JP): ja-JP-Wavenet-A
- **Korean** (ko-KR): ko-KR-Wavenet-A
- **Chinese** (zh-CN): zh-CN-Wavenet-A
- **Arabic** (ar-XA): ar-XA-Wavenet-A
- **Hindi** (hi-IN): hi-IN-Wavenet-A
- **Thai** (th-TH): th-TH-Standard-A
- **Vietnamese** (vi-VN): vi-VN-Standard-A

## Audio Formats

- **MP3**: Most compatible, smaller file size
- **WAV**: Uncompressed, highest quality
- **OGG**: Open source, good compression
- **FLAC**: Lossless compression

## Usage Examples

### JavaScript/Node.js

```javascript
const axios = require('axios');

// Text-to-Speech
async function textToSpeech(text) {
  const response = await axios.post('http://localhost:3000/api/translation/text-to-speech', {
    text: text,
    languageCode: 'en-US',
    audioFormat: 'mp3'
  }, {
    responseType: 'arraybuffer'
  });
  
  // Save audio file
  require('fs').writeFileSync('output.mp3', response.data);
}

// Translate and Speak
async function translateAndSpeak(text, chatflowId) {
  const response = await axios.post('http://localhost:3000/api/translation/translate-and-speak', {
    message: text,
    chatflowId: chatflowId,
    sourceLanguage: 'en',
    targetLanguage: 'es',
    audioFormat: 'mp3',
    includeAudioInResponse: true
  });
  
  console.log('Translated:', response.data.data.translatedText);
  
  if (response.data.data.audioContent) {
    const audioBuffer = Buffer.from(response.data.data.audioContent, 'base64');
    require('fs').writeFileSync('translated.mp3', audioBuffer);
  }
}
```

### cURL Examples

```bash
# Text-to-Speech
curl -X POST http://localhost:3000/api/translation/text-to-speech \
  -H "Content-Type: application/json" \
  -d '{"text": "Hello World", "audioFormat": "mp3"}' \
  --output speech.mp3

# Translate and Speak
curl -X POST http://localhost:3000/api/translation/translate-and-speak \
  -H "Content-Type: application/json" \
  -d '{
    "message": "Hello, how are you?",
    "chatflowId": "your-chatflow-id",
    "sourceLanguage": "en",
    "targetLanguage": "es",
    "audioFormat": "mp3"
  }'

# Get Voices
curl http://localhost:3000/api/translation/voices?languageCode=en-US
```

## Testing

Run the integration test:

```bash
node test-text-to-speech-integration.js
```

This will test all TTS endpoints and generate sample audio files.

## Error Handling

Common error responses:

```json
{
  "success": false,
  "error": "Permission denied",
  "message": "Check your Google Cloud credentials and permissions for Text-to-Speech API"
}
```

**Common Issues:**
1. **Permission denied**: Check Google Cloud credentials and API enablement
2. **Invalid argument**: Verify language codes and voice names
3. **Resource exhausted**: API quota exceeded
4. **Missing chatflowId**: Required for translation endpoints

## Best Practices

1. **Voice Selection**: Use WaveNet voices for better quality
2. **Audio Format**: Use MP3 for web applications, WAV for high quality
3. **Rate Limiting**: Be mindful of API quotas
4. **Caching**: Cache generated audio for repeated text
5. **Error Handling**: Always handle TTS failures gracefully

## Integration with Existing Features

The TTS integration works seamlessly with your existing:
- **Translation API**: Enhanced with audio output
- **Speech-to-Text**: Complete audio pipeline
- **Flowise Integration**: Uses same chatflow IDs
- **Rate Limiting**: Respects existing limits

## Next Steps

1. Set up Google Cloud credentials
2. Test the basic text-to-speech functionality
3. Integrate with your frontend application
4. Customize voice settings for your use case
5. Implement audio caching for better performance

For more information, visit the [Google Cloud Text-to-Speech documentation](https://cloud.google.com/text-to-speech).
