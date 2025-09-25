const axios = require('axios');

// Test script to verify Flowise integration
async function testFlowiseIntegration() {
  const chatflowId = '32547d3e-ba39-4604-a904-da0c516e17b1';
  const apiUrl = process.env.FLOWISE_API_URL || 'https://cloud.flowiseai.com';
  const apiKey = process.env.FLOWISE_API_KEY;

  if (!apiKey) {
    console.error('❌ FLOWISE_API_KEY environment variable is not set');
    return;
  }

  console.log('🧪 Testing Flowise Integration...');
  console.log(`📡 API URL: ${apiUrl}`);
  console.log(`🔑 API Key: ${apiKey ? 'Set' : 'Not Set'}`);
  console.log(`🆔 Chatflow ID: ${chatflowId}`);

  try {
    // Test 1: Health check
    console.log('\n1️⃣ Testing Flowise health check...');
    const healthResponse = await axios.get(`${apiUrl}/api/v1/ping`, {
      headers: {
        'X-API-KEY': apiKey,
        'Content-Type': 'application/json'
      },
      timeout: 10000
    });
    console.log('✅ Flowise health check passed:', healthResponse.data);

    // Test 2: Get chatflows
    console.log('\n2️⃣ Testing get chatflows...');
    const chatflowsResponse = await axios.get(`${apiUrl}/api/v1/chatflows`, {
      headers: {
        'X-API-KEY': apiKey,
        'Content-Type': 'application/json'
      },
      timeout: 10000
    });
    console.log('✅ Chatflows retrieved:', chatflowsResponse.data);

    // Test 3: Test simple chat message
    console.log('\n3️⃣ Testing simple chat message...');
    const chatResponse = await axios.post(`${apiUrl}/api/v1/prediction/${chatflowId}`, {
      question: 'Hello, can you help me with travel recommendations?',
      history: []
    }, {
      headers: {
        'X-API-KEY': apiKey,
        'Content-Type': 'application/json'
      },
      timeout: 30000
    });
    console.log('✅ Chat message successful:', chatResponse.data);

  } catch (error) {
    console.error('❌ Error testing Flowise integration:');
    if (error.response) {
      console.error('Status:', error.response.status);
      console.error('Data:', error.response.data);
    } else {
      console.error('Message:', error.message);
    }
  }
}

// Run the test
testFlowiseIntegration();
