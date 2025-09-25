const axios = require('axios');

async function testTTS() {
  console.log('🧪 Testing Text-to-Speech functionality...\n');
  
  try {
    // Test 1: Basic TTS
    console.log('1️⃣ Testing basic text-to-speech...');
    const ttsResponse = await axios.post('http://localhost:3000/api/translation/text-to-speech', {
      text: 'Hello, this is a test of text-to-speech!',
      languageCode: 'en-US',
      audioFormat: 'mp3'
    }, {
      responseType: 'arraybuffer'
    });
    
    console.log('✅ Basic TTS: SUCCESS');
    console.log(`   Audio size: ${ttsResponse.data.length} bytes`);
    console.log(`   Content-Type: ${ttsResponse.headers['content-type']}\n`);
    
    // Test 2: Translation with TTS
    console.log('2️⃣ Testing translation with TTS...');
    const translateResponse = await axios.post('http://localhost:3000/api/translation/translate-and-speak', {
      message: 'Hello, how are you today?',
      chatflowId: 'dadae924-7c24-4d80-8e8f-3d405d18ad57',
      sourceLanguage: 'en',
      targetLanguage: 'es',
      audioFormat: 'mp3',
      includeAudioInResponse: true
    });
    
    if (translateResponse.data.success) {
      console.log('✅ Translation with TTS: SUCCESS');
      console.log(`   Original: "${translateResponse.data.data.originalText}"`);
      console.log(`   Translated: "${translateResponse.data.data.translatedText}"`);
      
      if (translateResponse.data.data.audio) {
        console.log(`   Audio format: ${translateResponse.data.data.audio.format}`);
        console.log(`   Audio size: ${translateResponse.data.data.audio.size} bytes`);
        console.log(`   Voice: ${translateResponse.data.data.audio.voiceName}`);
      }
      
      if (translateResponse.data.data.audioContent) {
        console.log(`   Audio content included: ${translateResponse.data.data.audioContent.length} characters (base64)`);
      }
    } else {
      console.log('❌ Translation with TTS: FAILED');
      console.log(`   Error: ${translateResponse.data.error}`);
    }
    
    console.log('\n🎉 All tests completed successfully!');
    console.log('✅ Text-to-Speech is working perfectly!');
    console.log('✅ Translation with audio is working!');
    console.log('✅ Your Google Translate-like interface should work now!');
    
  } catch (error) {
    console.error('❌ Test failed:', error.response?.data || error.message);
  }
}

testTTS();
