// Test script for Price Advisor integration
const axios = require('axios');

const BASE_URL = 'http://localhost:3000';

async function testPriceAdvisor() {
  console.log('🧪 Testing Price Advisor Integration...\n');

  try {
    // Test 1: Basic price advice
    console.log('1️⃣ Testing basic price advice...');
    const priceAdviceResponse = await axios.post(`${BASE_URL}/api/scam-prevention/price-advice`, {
      item: 'iPhone 15',
      price: 1200,
      location: 'New York',
      currency: 'USD',
      chatflowId: '07afcffe-f864-4a73-8a28-9cbf096919e5',
      context: {
        marketType: 'shop',
        itemCategory: 'electronics',
        sellerType: 'official',
        timeOfDay: 'afternoon',
        season: 'peak'
      }
    });

    console.log('✅ Price advice response:', {
      success: priceAdviceResponse.data.success,
      message: priceAdviceResponse.data.message,
      advice: priceAdviceResponse.data.data?.advice?.substring(0, 100) + '...'
    });

    // Test 2: Test endpoint
    console.log('\n2️⃣ Testing price advisor test endpoint...');
    const testResponse = await axios.post(`${BASE_URL}/api/scam-prevention/test`, {
      testType: 'price',
      chatflowId: '07afcffe-f864-4a73-8a28-9cbf096919e5'
    });

    console.log('✅ Test response:', {
      success: testResponse.data.success,
      message: testResponse.data.message
    });

    // Test 3: General safety advice
    console.log('\n3️⃣ Testing general safety advice...');
    const safetyAdviceResponse = await axios.post(`${BASE_URL}/api/scam-prevention/advice`, {
      query: 'How to avoid tourist scams in Paris?',
      location: 'Paris, France',
      chatflowId: '07afcffe-f864-4a73-8a28-9cbf096919e5',
      adviceType: 'safety'
    });

    console.log('✅ Safety advice response:', {
      success: safetyAdviceResponse.data.success,
      message: safetyAdviceResponse.data.message,
      advice: safetyAdviceResponse.data.data?.advice?.substring(0, 100) + '...'
    });

    console.log('\n🎉 All tests passed! Price Advisor backend is working correctly.');

  } catch (error) {
    console.error('❌ Test failed:', {
      message: error.message,
      status: error.response?.status,
      data: error.response?.data
    });
  }
}

// Run the test
testPriceAdvisor();
