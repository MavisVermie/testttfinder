# Local Transportation Helper API - Test Commands

This document contains test commands and examples for the Local Transportation Helper API.

## Prerequisites

1. Make sure your server is running:
   ```bash
   npm start
   # or
   npm run dev
   ```

2. The server should be running on `http://localhost:3000`

## Test Commands

### 1. Check API Status and Help

#### Get API Overview
```bash
curl -X GET http://localhost:3000/
```

#### Get Transportation API Help
```bash
curl -X GET http://localhost:3000/api/transportation/help
```

### 2. Get Transportation Options

#### Basic Transportation Options (All Modes)
```bash
curl -X POST http://localhost:3000/api/transportation/options \
  -H "Content-Type: application/json" \
  -d '{
    "from": "Times Square, New York",
    "to": "Central Park, New York"
  }'
```

#### Transportation Options with Preferences
```bash
curl -X POST http://localhost:3000/api/transportation/options \
  -H "Content-Type: application/json" \
  -d '{
    "from": "Airport Terminal 1",
    "to": "Downtown Hotel",
    "mode": "all",
    "preferences": {
      "ecoFriendly": true,
      "budget": 15,
      "maxTime": 45
    }
  }'
```

#### Bus-Only Options
```bash
curl -X POST http://localhost:3000/api/transportation/options \
  -H "Content-Type: application/json" \
  -d '{
    "from": "University Campus",
    "to": "Shopping Mall",
    "mode": "bus"
  }'
```

#### Metro-Only Options
```bash
curl -X POST http://localhost:3000/api/transportation/options \
  -H "Content-Type: application/json" \
  -d '{
    "from": "Downtown Station",
    "to": "Airport Station",
    "mode": "metro"
  }'
```

#### Rideshare-Only Options
```bash
curl -X POST http://localhost:3000/api/transportation/options \
  -H "Content-Type: application/json" \
  -d '{
    "from": "Hotel Lobby",
    "to": "Restaurant District",
    "mode": "rideshare"
  }'
```

### 3. Get Real-Time Updates

#### All Transportation Updates
```bash
curl -X GET http://localhost:3000/api/transportation/realtime
```

#### Bus-Specific Updates
```bash
curl -X GET "http://localhost:3000/api/transportation/realtime?transportType=bus"
```

#### Metro-Specific Updates
```bash
curl -X GET "http://localhost:3000/api/transportation/realtime?transportType=metro"
```

#### Rideshare-Specific Updates
```bash
curl -X GET "http://localhost:3000/api/transportation/realtime?transportType=rideshare"
```

### 4. Get Detailed Directions

#### Bus Directions
```bash
curl -X POST http://localhost:3000/api/transportation/directions \
  -H "Content-Type: application/json" \
  -d '{
    "from": "City Center",
    "to": "Suburb Station",
    "transportType": "bus",
    "routeId": "B1"
  }'
```

#### Metro Directions
```bash
curl -X POST http://localhost:3000/api/transportation/directions \
  -H "Content-Type: application/json" \
  -d '{
    "from": "Main Street Station",
    "to": "Airport Terminal",
    "transportType": "metro",
    "routeId": "M1"
  }'
```

#### Rideshare Directions
```bash
curl -X POST http://localhost:3000/api/transportation/directions \
  -H "Content-Type: application/json" \
  -d '{
    "from": "Hotel Address",
    "to": "Tourist Attraction",
    "transportType": "rideshare"
  }'
```

### 5. Get System Status

#### Overall Transportation System Status
```bash
curl -X GET http://localhost:3000/api/transportation/status
```

## PowerShell Commands (Windows)

If you're using PowerShell on Windows, here are the equivalent commands:

### Get Transportation Options
```powershell
Invoke-RestMethod -Uri "http://localhost:3000/api/transportation/options" -Method POST -ContentType "application/json" -Body '{
  "from": "Times Square, New York",
  "to": "Central Park, New York",
  "mode": "all"
}'
```

### Get Real-Time Updates
```powershell
Invoke-RestMethod -Uri "http://localhost:3000/api/transportation/realtime" -Method GET
```

### Get System Status
```powershell
Invoke-RestMethod -Uri "http://localhost:3000/api/transportation/status" -Method GET
```

## JavaScript/Node.js Test Script

Create a file called `test-transportation.js`:

```javascript
const axios = require('axios');

const BASE_URL = 'http://localhost:3000';

async function testTransportationAPI() {
  try {
    console.log('🚀 Testing Local Transportation Helper API\n');

    // Test 1: Get transportation options
    console.log('1. Getting transportation options...');
    const optionsResponse = await axios.post(`${BASE_URL}/api/transportation/options`, {
      from: 'Times Square, New York',
      to: 'Central Park, New York',
      mode: 'all',
      preferences: {
        ecoFriendly: true,
        budget: 20
      }
    });
    console.log('✅ Options:', JSON.stringify(optionsResponse.data, null, 2));

    // Test 2: Get real-time updates
    console.log('\n2. Getting real-time updates...');
    const realtimeResponse = await axios.get(`${BASE_URL}/api/transportation/realtime`);
    console.log('✅ Real-time updates:', JSON.stringify(realtimeResponse.data, null, 2));

    // Test 3: Get directions
    console.log('\n3. Getting directions...');
    const directionsResponse = await axios.post(`${BASE_URL}/api/transportation/directions`, {
      from: 'Airport Terminal',
      to: 'Downtown Hotel',
      transportType: 'metro'
    });
    console.log('✅ Directions:', JSON.stringify(directionsResponse.data, null, 2));

    // Test 4: Get system status
    console.log('\n4. Getting system status...');
    const statusResponse = await axios.get(`${BASE_URL}/api/transportation/status`);
    console.log('✅ System status:', JSON.stringify(statusResponse.data, null, 2));

    console.log('\n🎉 All tests completed successfully!');
  } catch (error) {
    console.error('❌ Test failed:', error.response?.data || error.message);
  }
}

testTransportationAPI();
```

Run the test script:
```bash
node test-transportation.js
```

## Expected Response Examples

### Transportation Options Response
```json
{
  "success": true,
  "data": {
    "origin": "Times Square, New York",
    "destination": "Central Park, New York",
    "timestamp": "2024-01-15T10:30:00.000Z",
    "options": [
      {
        "type": "bus",
        "name": "Public Bus",
        "estimatedTime": "25-35 minutes",
        "cost": "$2.50",
        "description": "Most economical option",
        "pros": ["Cheapest option", "Frequent service", "Covers most areas"],
        "cons": ["Longer travel time", "May require transfers", "Limited to bus routes"],
        "realTimeInfo": {
          "realTimeStatus": "On time",
          "delays": []
        }
      }
    ],
    "recommendations": [
      {
        "type": "cheapest",
        "option": { "type": "bus", "name": "Public Bus", "cost": "$2.50" },
        "reason": "Most cost-effective option for your budget"
      }
    ]
  },
  "message": "Transportation options retrieved successfully"
}
```

### Real-Time Updates Response
```json
{
  "success": true,
  "data": {
    "timestamp": "2024-01-15T10:30:00.000Z",
    "bus": {
      "realTimeStatus": "On time",
      "delays": []
    },
    "metro": {
      "realTimeStatus": "Minor delays on Red Line",
      "delays": ["Red Line: 5-10 min delay due to signal issues"]
    },
    "rideshare": {
      "uber": {
        "available": true,
        "estimatedWait": "3-5 min"
      },
      "lyft": {
        "available": true,
        "estimatedWait": "2-4 min"
      }
    }
  },
  "message": "Real-time updates retrieved successfully"
}
```

## Features Included

✅ **Transportation Options**: Compare bus, metro, and rideshare options  
✅ **Real-Time Updates**: Live delays, status, and availability  
✅ **Cost Estimation**: Accurate pricing for all transportation types  
✅ **Travel Time**: Estimated duration for each option  
✅ **Route Planning**: Step-by-step directions  
✅ **Recommendations**: Smart suggestions based on preferences  
✅ **System Status**: Overall transportation system health  
✅ **Eco-Friendly Options**: Environmental impact considerations  
✅ **Accessibility**: Support for accessibility preferences  

## Next Steps

1. **Integrate Real APIs**: Replace mock data with actual Google Maps, Uber, Lyft APIs
2. **Add More Cities**: Expand beyond mock data to real city transportation systems
3. **User Preferences**: Store and learn from user transportation preferences
4. **Push Notifications**: Real-time alerts for delays and updates
5. **Mobile App**: Create a mobile interface for the transportation helper

## Troubleshooting

- **Server not running**: Make sure to run `npm start` or `npm run dev`
- **Port conflicts**: Check if port 3000 is available
- **CORS issues**: The API is configured for localhost development
- **Validation errors**: Check that required fields are provided in requests
