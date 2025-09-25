const http = require('http');

const postData = JSON.stringify({
  userMessage: "I want to visit Paris for 3 days, I love food and culture",
  chatflowId: "32547d3e-ba39-4604-a904-da0c516e17b1"
});

const options = {
  hostname: 'localhost',
  port: 3000,
  path: '/api/recommendations/personalized',
  method: 'POST',
  headers: {
    'Content-Type': 'application/json',
    'Content-Length': Buffer.byteLength(postData)
  }
};

console.log('Testing recommendations API...');
console.log('Request data:', postData);

const req = http.request(options, (res) => {
  console.log(`Status: ${res.statusCode}`);
  console.log(`Headers:`, res.headers);
  
  let data = '';
  res.on('data', (chunk) => {
    data += chunk;
  });
  
  res.on('end', () => {
    console.log('Response:', data);
    try {
      const parsed = JSON.parse(data);
      console.log('Parsed response:', JSON.stringify(parsed, null, 2));
    } catch (e) {
      console.log('Could not parse JSON response');
    }
  });
});

req.on('error', (e) => {
  console.error(`Problem with request: ${e.message}`);
});

req.write(postData);
req.end();
