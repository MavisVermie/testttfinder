## AI Travel Assistant API

### Audio Translation

Endpoint: `POST /api/translation/audio`

Form-Data fields:
- file (required): audio file (webm/ogg/opus/mp3/wav/flac)
- chatflowId (optional): Flowise chatflow ID (defaults to `DEFAULT_TRANSLATION_CHATFLOW_ID`)
- sourceLanguage (optional): e.g., `en`
- targetLanguage (optional): e.g., `es`
- languageCode (optional): STT recognition language, default `GOOGLE_SPEECH_LANGUAGE_CODE`

Response example:
```json
{
  "success": true,
  "data": {
    "originalText": "Hello",
    "translatedText": "Hola",
    "sourceLanguage": "auto",
    "targetLanguage": "es",
    "sttLanguageCode": "en-US",
    "timestamp": "2025-09-23T00:00:00.000Z"
  }
}
```

Setup:
- Set `GOOGLE_SPEECH_API_KEY` and `GOOGLE_SPEECH_LANGUAGE_CODE` in `.env`.
- Optionally set `DEFAULT_TRANSLATION_CHATFLOW_ID`.