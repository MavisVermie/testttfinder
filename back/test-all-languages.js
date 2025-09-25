const axios = require('axios');

async function testAllLanguages() {
  console.log('🌍 Testing Text-to-Speech for all supported languages...\n');
  
  const languages = [
    { code: 'en', name: 'English', text: 'Hello, how are you?' },
    { code: 'es', name: 'Spanish', text: 'Hola, ¿cómo estás?' },
    { code: 'fr', name: 'French', text: 'Bonjour, comment allez-vous?' },
    { code: 'de', name: 'German', text: 'Hallo, wie geht es dir?' },
    { code: 'it', name: 'Italian', text: 'Ciao, come stai?' },
    { code: 'pt', name: 'Portuguese', text: 'Olá, como você está?' },
    { code: 'ru', name: 'Russian', text: 'Привет, как дела?' },
    { code: 'ja', name: 'Japanese', text: 'こんにちは、元気ですか？' },
    { code: 'ko', name: 'Korean', text: '안녕하세요, 어떻게 지내세요?' },
    { code: 'zh', name: 'Chinese', text: '你好，你好吗？' },
    { code: 'ar', name: 'Arabic', text: 'مرحبا، كيف حالك؟' },
    { code: 'hi', name: 'Hindi', text: 'नमस्ते, आप कैसे हैं?' },
    { code: 'th', name: 'Thai', text: 'สวัสดี คุณเป็นอย่างไร?' },
    { code: 'vi', name: 'Vietnamese', text: 'Xin chào, bạn có khỏe không?' }
  ];

  const results = [];

  for (const lang of languages) {
    try {
      console.log(`🔊 Testing ${lang.name} (${lang.code})...`);
      
      const response = await axios.post('http://localhost:3000/api/translation/text-to-speech', {
        text: lang.text,
        languageCode: getLanguageCode(lang.code),
        audioFormat: 'mp3'
      }, {
        responseType: 'arraybuffer'
      });
      
      const audioSize = response.data.length;
      console.log(`   ✅ SUCCESS - Audio size: ${audioSize} bytes`);
      results.push({ language: lang.name, status: 'SUCCESS', size: audioSize });
      
    } catch (error) {
      console.log(`   ❌ FAILED - ${error.response?.data?.message || error.message}`);
      results.push({ language: lang.name, status: 'FAILED', error: error.response?.data?.message || error.message });
    }
  }

  console.log('\n📊 Test Results Summary:');
  console.log('=' .repeat(50));
  
  const successful = results.filter(r => r.status === 'SUCCESS').length;
  const failed = results.filter(r => r.status === 'FAILED').length;
  
  results.forEach(result => {
    const status = result.status === 'SUCCESS' ? '✅' : '❌';
    const info = result.status === 'SUCCESS' ? `${result.size} bytes` : result.error;
    console.log(`${status} ${result.language}: ${info}`);
  });
  
  console.log('=' .repeat(50));
  console.log(`🎯 Overall: ${successful}/${results.length} languages working`);
  
  if (successful === results.length) {
    console.log('🎉 All languages are working perfectly!');
  } else {
    console.log(`⚠️ ${failed} languages need attention`);
  }
}

function getLanguageCode(langCode) {
  const mapping = {
    'en': 'en-US',
    'es': 'es-ES',
    'fr': 'fr-FR',
    'de': 'de-DE',
    'it': 'it-IT',
    'pt': 'pt-PT',
    'ru': 'ru-RU',
    'ja': 'ja-JP',
    'ko': 'ko-KR',
    'zh': 'cmn-CN', // Fixed for Chinese
    'ar': 'ar-XA',
    'hi': 'hi-IN',
    'th': 'th-TH',
    'vi': 'vi-VN'
  };
  return mapping[langCode] || 'en-US';
}

testAllLanguages().catch(console.error);
