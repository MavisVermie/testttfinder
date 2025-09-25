const axios = require('axios');
const FormData = require('form-data');
const fs = require('fs');
const path = require('path');

// Configuration
const BASE_URL = 'http://localhost:3000';
const CHATFLOW_ID = 'your-chatflow-id-here'; // Replace with your actual chatflow ID

// Test data
const testText = 'Hello, this is a test of the text-to-speech integration!';
const testTranslation = {
  message: 'Hello, how are you today?',
  sourceLanguage: 'en',
  targetLanguage: 'es'
};

async function testTextToSpeech() {
  console.log('🎤 Testing Text-to-Speech endpoint...');
  
  try {
    const response = await axios.post(`${BASE_URL}/api/translation/text-to-speech`, {
      text: testText,
      languageCode: 'en-US',
      audioFormat: 'mp3',
      speakingRate: 1.0,
      pitch: 0.0
    }, {
      responseType: 'arraybuffer',
      headers: {
        'Content-Type': 'application/json'
      }
    });

    // Save the audio file
    const audioPath = path.join(__dirname, 'test-speech.mp3');
    fs.writeFileSync(audioPath, response.data);
    
    console.log('✅ Text-to-Speech test passed!');
    console.log(`📁 Audio saved to: ${audioPath}`);
    console.log(`📊 Audio size: ${response.data.length} bytes`);
    console.log(`🎵 Content-Type: ${response.headers['content-type']}`);
    
    return true;
  } catch (error) {
    console.error('❌ Text-to-Speech test failed:', error.response?.data || error.message);
    return false;
  }
}

async function testTranslateAndSpeak() {
  console.log('\n🌍 Testing Translate and Speak endpoint...');
  
  try {
    const response = await axios.post(`${BASE_URL}/api/translation/translate-and-speak`, {
      message: testTranslation.message,
      chatflowId: CHATFLOW_ID,
      sourceLanguage: testTranslation.sourceLanguage,
      targetLanguage: testTranslation.targetLanguage,
      audioFormat: 'mp3',
      includeAudioInResponse: true
    });

    if (response.data.success) {
      console.log('✅ Translate and Speak test passed!');
      console.log(`📝 Original: ${response.data.data.originalText}`);
      console.log(`🌍 Translated: ${response.data.data.translatedText}`);
      
      if (response.data.data.audio) {
        console.log(`🎵 Audio format: ${response.data.data.audio.format}`);
        console.log(`📊 Audio size: ${response.data.data.audio.size} bytes`);
        console.log(`🗣️ Voice: ${response.data.data.audio.voiceName}`);
        
        // Save audio if included in response
        if (response.data.data.audioContent) {
          const audioPath = path.join(__dirname, 'test-translated-speech.mp3');
          const audioBuffer = Buffer.from(response.data.data.audioContent, 'base64');
          fs.writeFileSync(audioPath, audioBuffer);
          console.log(`📁 Translated audio saved to: ${audioPath}`);
        }
      }
      
      return true;
    } else {
      console.error('❌ Translate and Speak test failed:', response.data.error);
      return false;
    }
  } catch (error) {
    console.error('❌ Translate and Speak test failed:', error.response?.data || error.message);
    return false;
  }
}

async function testGetVoices() {
  console.log('\n🗣️ Testing Get Voices endpoint...');
  
  try {
    const response = await axios.get(`${BASE_URL}/api/translation/voices?languageCode=en-US`);
    
    if (response.data.success) {
      console.log('✅ Get Voices test passed!');
      console.log(`📊 Found ${response.data.data.voices.length} voices for en-US`);
      
      // Show first few voices
      const voices = response.data.data.voices.slice(0, 3);
      voices.forEach(voice => {
        console.log(`  - ${voice.name} (${voice.ssmlGender})`);
      });
      
      return true;
    } else {
      console.error('❌ Get Voices test failed:', response.data.error);
      return false;
    }
  } catch (error) {
    console.error('❌ Get Voices test failed:', error.response?.data || error.message);
    return false;
  }
}

async function testGetTTSLanguages() {
  console.log('\n🌐 Testing Get TTS Languages endpoint...');
  
  try {
    const response = await axios.get(`${BASE_URL}/api/translation/tts-languages`);
    
    if (response.data.success) {
      console.log('✅ Get TTS Languages test passed!');
      console.log(`📊 Supported languages: ${response.data.data.languages.length}`);
      console.log(`🎵 Audio formats: ${response.data.data.audioFormats.join(', ')}`);
      
      // Show first few languages
      const languages = response.data.data.languages.slice(0, 5);
      languages.forEach(lang => {
        console.log(`  - ${lang.name} (${lang.code}) - ${lang.defaultVoice}`);
      });
      
      return true;
    } else {
      console.error('❌ Get TTS Languages test failed:', response.data.error);
      return false;
    }
  } catch (error) {
    console.error('❌ Get TTS Languages test failed:', error.response?.data || error.message);
    return false;
  }
}

async function testServerHealth() {
  console.log('🏥 Testing server health...');
  
  try {
    const response = await axios.get(`${BASE_URL}/`);
    
    if (response.data.status === 'running') {
      console.log('✅ Server is running!');
      console.log(`📚 API Version: ${response.data.version}`);
      
      // Check if TTS endpoints are listed
      const endpoints = response.data.endpoints;
      const ttsEndpoints = [
        'textToSpeech',
        'translateAndSpeak', 
        'audioTranslateSpeak',
        'voices',
        'ttsLanguages'
      ];
      
      const missingEndpoints = ttsEndpoints.filter(endpoint => !endpoints[endpoint]);
      if (missingEndpoints.length === 0) {
        console.log('✅ All TTS endpoints are available!');
        return true;
      } else {
        console.log(`⚠️ Missing TTS endpoints: ${missingEndpoints.join(', ')}`);
        return false;
      }
    } else {
      console.error('❌ Server is not running properly');
      return false;
    }
  } catch (error) {
    console.error('❌ Server health check failed:', error.message);
    return false;
  }
}

async function runAllTests() {
  console.log('🚀 Starting Text-to-Speech Integration Tests\n');
  console.log('=' .repeat(50));
  
  const results = {
    serverHealth: await testServerHealth(),
    textToSpeech: await testTextToSpeech(),
    translateAndSpeak: await testTranslateAndSpeak(),
    getVoices: await testGetVoices(),
    getTTSLanguages: await testGetTTSLanguages()
  };
  
  console.log('\n' + '=' .repeat(50));
  console.log('📊 Test Results Summary:');
  console.log('=' .repeat(50));
  
  Object.entries(results).forEach(([test, passed]) => {
    const status = passed ? '✅ PASS' : '❌ FAIL';
    console.log(`${status} ${test}`);
  });
  
  const passedTests = Object.values(results).filter(Boolean).length;
  const totalTests = Object.keys(results).length;
  
  console.log('=' .repeat(50));
  console.log(`🎯 Overall: ${passedTests}/${totalTests} tests passed`);
  
  if (passedTests === totalTests) {
    console.log('🎉 All tests passed! Text-to-Speech integration is working perfectly!');
  } else {
    console.log('⚠️ Some tests failed. Check the error messages above.');
  }
  
  console.log('\n📝 Next Steps:');
  console.log('1. Make sure your Google Cloud credentials are set up correctly');
  console.log('2. Ensure the Text-to-Speech API is enabled in your Google Cloud project');
  console.log('3. Update the CHATFLOW_ID in this test file with your actual Flowise chatflow ID');
  console.log('4. Test the audio files generated in the current directory');
}

// Run the tests
if (require.main === module) {
  runAllTests().catch(console.error);
}

module.exports = {
  testTextToSpeech,
  testTranslateAndSpeak,
  testGetVoices,
  testGetTTSLanguages,
  testServerHealth,
  runAllTests
};
