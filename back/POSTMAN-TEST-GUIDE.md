# 🚀 Postman Test Guide - Local Transportation Helper API

This guide will help you test the Local Transportation Helper API using Postman.

## 📋 Prerequisites

1. **Postman Installed** - Download from [postman.com](https://www.postman.com/downloads/)
2. **Server Running** - Make sure your backend is running on `http://localhost:3000`
3. **Collection Imported** - Import the `Transportation-API.postman_collection.json` file

## 🚀 Quick Start

### Step 1: Import the Collection
1. Open Postman
2. Click **Import** button
3. Select the `Transportation-API.postman_collection.json` file
4. Click **Import**

### Step 2: Set Up Environment (Optional)
1. Click on **Environments** in the left sidebar
2. Click **Create Environment**
3. Name it "Local Development"
4. Add variable:
   - **Variable**: `baseUrl`
   - **Initial Value**: `http://localhost:3000`
   - **Current Value**: `http://localhost:3000`
5. Click **Save**

### Step 3: Start Testing
1. Select the **Local Transportation Helper API** collection
2. Select the **Local Development** environment (if created)
3. Start with **"1. API Overview"** → **"Get API Status"**

## 📚 Test Collection Structure

### **1. API Overview**
- **Get API Status** - Check if the API is running
- **Get Transportation Help** - Get API documentation

### **2. Transportation Options**
- **Get All Transportation Options** - Compare all transport types
- **Get Options with Preferences** - Test with user preferences
- **Get Bus-Only Options** - Test bus-specific options
- **Get Metro-Only Options** - Test metro/subway options
- **Get Rideshare-Only Options** - Test Uber/Lyft options

### **3. Real-Time Updates**
- **Get All Real-Time Updates** - All transport updates
- **Get Bus Real-Time Updates** - Bus-specific updates
- **Get Metro Real-Time Updates** - Metro-specific updates
- **Get Rideshare Real-Time Updates** - Rideshare-specific updates

### **4. Directions**
- **Get Bus Directions** - Step-by-step bus directions
- **Get Metro Directions** - Step-by-step metro directions
- **Get Rideshare Directions** - Step-by-step rideshare directions

### **5. System Status**
- **Get System Status** - Overall system health

### **6. Error Testing**
- **Invalid Request - Missing Fields** - Test validation
- **Invalid Request - Wrong Mode** - Test parameter validation
- **Invalid Request - Wrong Transport Type** - Test transport type validation

## 🧪 Step-by-Step Testing

### **Test 1: Basic API Health Check**
1. Select **"1. API Overview"** → **"Get API Status"**
2. Click **Send**
3. **Expected Result**: Status 200 with API information

### **Test 2: Get Transportation Options**
1. Select **"2. Transportation Options"** → **"Get All Transportation Options"**
2. Click **Send**
3. **Expected Result**: Status 200 with transportation options including bus, metro, and rideshare

### **Test 3: Test with Preferences**
1. Select **"2. Transportation Options"** → **"Get Options with Preferences"**
2. Click **Send**
3. **Expected Result**: Status 200 with eco-friendly recommendations

### **Test 4: Real-Time Updates**
1. Select **"3. Real-Time Updates"** → **"Get All Real-Time Updates"**
2. Click **Send**
3. **Expected Result**: Status 200 with real-time status for all transport types

### **Test 5: Get Directions**
1. Select **"4. Directions"** → **"Get Bus Directions"**
2. Click **Send**
3. **Expected Result**: Status 200 with step-by-step bus directions

### **Test 6: System Status**
1. Select **"5. System Status"** → **"Get System Status"**
2. Click **Send**
3. **Expected Result**: Status 200 with overall system health

### **Test 7: Error Handling**
1. Select **"6. Error Testing"** → **"Invalid Request - Missing Fields"**
2. Click **Send**
3. **Expected Result**: Status 400 with validation error message

## 📊 Expected Response Examples

### **Transportation Options Response**
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

### **Real-Time Updates Response**
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

### **Error Response Example**
```json
{
  "success": false,
  "error": "Validation error",
  "message": "\"to\" is required",
  "details": [
    {
      "message": "\"to\" is required",
      "path": ["to"],
      "type": "any.required",
      "context": {
        "label": "to",
        "key": "to"
      }
    }
  ]
}
```

## 🔧 Customizing Tests

### **Modify Request Bodies**
1. Click on any request in the collection
2. Go to the **Body** tab
3. Modify the JSON payload as needed
4. Click **Send**

### **Add New Test Cases**
1. Right-click on a folder in the collection
2. Select **Add Request**
3. Configure the request method, URL, headers, and body
4. Save the request

### **Create Test Scripts**
1. Select any request
2. Go to the **Tests** tab
3. Add JavaScript code to validate responses:

```javascript
// Example test script
pm.test("Status code is 200", function () {
    pm.response.to.have.status(200);
});

pm.test("Response has success field", function () {
    const jsonData = pm.response.json();
    pm.expect(jsonData).to.have.property('success');
    pm.expect(jsonData.success).to.be.true;
});

pm.test("Response has data field", function () {
    const jsonData = pm.response.json();
    pm.expect(jsonData).to.have.property('data');
});
```

## 🚨 Troubleshooting

### **Common Issues:**

1. **"Could not get any response"**
   - Check if your server is running (`npm start`)
   - Verify the URL is correct (`http://localhost:3000`)

2. **"Connection refused"**
   - Make sure the server is running on port 3000
   - Check if another application is using port 3000

3. **"Validation error"**
   - Check the request body format
   - Ensure all required fields are included

4. **"Internal server error"**
   - Check the server console for error messages
   - Verify all dependencies are installed

### **Debug Steps:**
1. Check server console for error messages
2. Verify request body format (valid JSON)
3. Check if all required fields are present
4. Test with simpler requests first

## 📈 Performance Testing

### **Load Testing with Postman**
1. Select a request
2. Click the **Runner** button
3. Select the collection
4. Set iterations and delay
5. Click **Start Test**

### **Monitor Response Times**
- Check the response time in the response section
- Look for any requests taking longer than 2 seconds

## 🎯 Advanced Testing Scenarios

### **Test Different Cities**
Modify the `from` and `to` fields to test different locations:
```json
{
  "from": "Los Angeles International Airport",
  "to": "Hollywood Walk of Fame",
  "mode": "all"
}
```

### **Test Edge Cases**
- Very long addresses
- Special characters in addresses
- Empty strings
- Very short addresses

### **Test Performance**
- Send multiple requests simultaneously
- Test with large request bodies
- Monitor memory usage

## 📝 Test Results Documentation

Keep track of your test results:

| Test Case | Status | Response Time | Notes |
|-----------|--------|---------------|-------|
| API Status | ✅ Pass | 45ms | Server running correctly |
| All Options | ✅ Pass | 120ms | All transport types returned |
| Bus Only | ✅ Pass | 95ms | Bus options filtered correctly |
| Error Handling | ✅ Pass | 25ms | Validation working properly |

## 🚀 Next Steps

1. **Automate Tests** - Use Postman's collection runner
2. **Add More Test Cases** - Cover edge cases and error scenarios
3. **Performance Testing** - Test with multiple concurrent requests
4. **Integration Testing** - Test with real transportation APIs
5. **Documentation** - Export test results and create reports

---

**Happy Testing! 🎉**

If you encounter any issues, check the server console for error messages and ensure all required fields are provided in your requests.
