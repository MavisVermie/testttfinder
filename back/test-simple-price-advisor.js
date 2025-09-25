// Simple test for Price Advisor service
const axios = require('axios');

const BASE_URL = 'http://localhost:3000';

async function testPriceAdvisor() {
  console.log('🧪 Testing Price Advisor Service...\n');

  try {
    // Test 1: Check if server is running
    console.log('1️⃣ Checking server status...');
    const healthResponse = await axios.get(`${BASE_URL}/`);
    console.log('✅ Server is running:', healthResponse.data.message);

    // Test 2: Test price advice endpoint
    console.log('\n2️⃣ Testing price advice endpoint...');
    const priceAdviceResponse = await axios.post(`${BASE_URL}/api/scam-prevention/price-advice`, {
      item: 'iPhone 15',
      price: 1200,
      location: 'New York',
      currency: 'USD',
      chatflowId: '07afcffe-f864-4a73-8a28-9cbf096919e5'
    });

    console.log('✅ Price advice response:', {
      success: priceAdviceResponse.data.success,
      message: priceAdviceResponse.data.message,
      hasAdvice: !!priceAdviceResponse.data.data?.advice
    });

    // Test 3: Test endpoint
    console.log('\n3️⃣ Testing test endpoint...');
    const testResponse = await axios.post(`${BASE_URL}/api/scam-prevention/test`, {
      testType: 'price',
      chatflowId: '07afcffe-f864-4a73-8a28-9cbf096919e5'
    });

    console.log('✅ Test response:', {
      success: testResponse.data.success,
      message: testResponse.data.message
    });

    console.log('\n🎉 Price Advisor service is working correctly!');

  } catch (error) {
    console.error('❌ Test failed:', {
      message: error.message,
      status: error.response?.status,
      data: error.response?.data
    });
    
    if (error.code === 'ECONNREFUSED') {
      console.log('\n💡 Make sure the server is running:');
      console.log('   cd back && npm start');
    }
  }
}

// Run the test
testPriceAdvisor();
