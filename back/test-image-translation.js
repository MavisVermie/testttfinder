const axios = require('axios');
const FormData = require('form-data');
const fs = require('fs');
const path = require('path');

// Test configuration
const API_BASE_URL = 'http://localhost:3000/api/translation';
const CHATFLOW_ID = process.env.DEFAULT_TRANSLATION_CHATFLOW_ID || 'your-chatflow-id-here';

async function testImageTranslation() {
    console.log('🖼️ Testing Image Translation API...\n');
    
    try {
        // Test 1: Check if the image endpoint exists
        console.log('1. Testing endpoint availability...');
        const healthResponse = await axios.get(`${API_BASE_URL.replace('/image', '')}/languages`);
        console.log('✅ Translation API is running');
        
        // Test 2: Test with a sample image (if available)
        console.log('\n2. Testing image translation...');
        
        // Create a simple test image (1x1 pixel PNG)
        const testImageBuffer = Buffer.from([
            0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, // PNG signature
            0x00, 0x00, 0x00, 0x0D, 0x49, 0x48, 0x44, 0x52, // IHDR chunk
            0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01, // 1x1 dimensions
            0x08, 0x02, 0x00, 0x00, 0x00, 0x90, 0x77, 0x53, // bit depth, color type, etc.
            0xDE, 0x00, 0x00, 0x00, 0x0C, 0x49, 0x44, 0x41, // IDAT chunk
            0x54, 0x08, 0x99, 0x01, 0x01, 0x00, 0x00, 0x00, // compressed data
            0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, // more compressed data
            0x00, 0x00, 0x00, 0x02, 0x00, 0x01, 0x00, 0x00, // more compressed data
            0x00, 0x00, 0x49, 0x45, 0x4E, 0x44, 0xAE, 0x42, // IEND chunk
            0x60, 0x82
        ]);
        
        const formData = new FormData();
        formData.append('file', testImageBuffer, {
            filename: 'test-image.png',
            contentType: 'image/png'
        });
        formData.append('chatflowId', CHATFLOW_ID);
        formData.append('sourceLanguage', 'auto');
        formData.append('targetLanguage', 'en');
        formData.append('prompt', 'Please analyze this image and translate any text you find from {sourceLanguage} to {targetLanguage}. If no text is found, describe what you see in the image.');
        
        const response = await axios.post(`${API_BASE_URL}/image`, formData, {
            headers: {
                ...formData.getHeaders()
            },
            timeout: 60000 // 60 seconds timeout for image processing
        });
        
        if (response.data.success) {
            console.log('✅ Image translation successful!');
            console.log('📊 Response:', JSON.stringify(response.data, null, 2));
        } else {
            console.log('❌ Image translation failed:', response.data.error);
        }
        
    } catch (error) {
        if (error.response) {
            console.log('❌ API Error:', error.response.status, error.response.data);
        } else if (error.code === 'ECONNREFUSED') {
            console.log('❌ Connection Error: Make sure the server is running on port 3000');
        } else {
            console.log('❌ Error:', error.message);
        }
    }
}

// Test 3: Test error handling
async function testErrorHandling() {
    console.log('\n3. Testing error handling...');
    
    try {
        // Test with no file
        const formData = new FormData();
        formData.append('chatflowId', CHATFLOW_ID);
        
        const response = await axios.post(`${API_BASE_URL}/image`, formData, {
            headers: {
                ...formData.getHeaders()
            }
        });
        
        console.log('❌ Expected error but got success:', response.data);
    } catch (error) {
        if (error.response && error.response.status === 400) {
            console.log('✅ Error handling works correctly - no file uploaded');
        } else {
            console.log('❌ Unexpected error:', error.message);
        }
    }
}

// Run tests
async function runTests() {
    console.log('🚀 Starting Image Translation Tests\n');
    console.log(`API URL: ${API_BASE_URL}`);
    console.log(`Chatflow ID: ${CHATFLOW_ID}\n`);
    
    await testImageTranslation();
    await testErrorHandling();
    
    console.log('\n✨ Tests completed!');
    console.log('\n📝 Usage Instructions:');
    console.log('1. Make sure your server is running: npm start');
    console.log('2. Open test-image-translation.html in your browser');
    console.log('3. Upload an image with text and test the translation');
    console.log('4. Make sure your Flowise chatflow supports image analysis');
}

runTests().catch(console.error);
