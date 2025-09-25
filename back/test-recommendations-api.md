# Test Recommendations API

This document provides comprehensive test examples for the new Personalized Recommendations API.

## Prerequisites

1. Ensure your server is running: `npm start`
2. Have your Flowise agent flow IDs ready
3. Set up your environment variables

## Test 1: Basic Personalized Recommendations

### Request
```bash
curl -X POST http://localhost:3000/api/recommendations/personalized \
  -H "Content-Type: application/json" \
  -d '{
    "location": "Paris, France",
    "interests": ["culture", "food", "art"],
    "budget": "medium",
    "duration": "1 week",
    "travelStyle": "tourist",
    "chatflowId": "your-recommendations-chatflow-id"
  }'
```

### Expected Response
```json
{
  "success": true,
  "data": {
    "recommendations": {
      "attractions": [...],
      "restaurants": [...],
      "activities": [...],
      "itinerary": {...},
      "tips": [...]
    },
    "metadata": {
      "location": "Paris, France",
      "interests": ["culture", "food", "art"],
      "budget": "medium",
      "duration": "1 week",
      "travelStyle": "tourist",
      "timestamp": "2024-01-15T10:30:00.000Z"
    }
  },
  "message": "Personalized recommendations generated successfully"
}
```

## Test 2: Cultural Etiquette

### Request
```bash
curl -X POST http://localhost:3000/api/recommendations/cultural-etiquette \
  -H "Content-Type: application/json" \
  -d '{
    "location": "Tokyo, Japan",
    "chatflowId": "your-cultural-etiquette-chatflow-id",
    "specificTopics": ["dining", "greetings", "business"]
  }'
```

### Expected Response
```json
{
  "success": true,
  "data": {
    "culturalEtiquette": {
      "generalEtiquette": {...},
      "diningEtiquette": {...},
      "socialEtiquette": {...},
      "dosAndDonts": {...},
      "languageTips": {...},
      "culturalNorms": {...}
    },
    "metadata": {
      "location": "Tokyo, Japan",
      "specificTopics": ["dining", "greetings", "business"],
      "timestamp": "2024-01-15T10:30:00.000Z"
    }
  },
  "message": "Cultural etiquette information retrieved successfully"
}
```

## Test 3: Comprehensive Recommendations

### Request
```bash
curl -X POST http://localhost:3000/api/recommendations/comprehensive \
  -H "Content-Type: application/json" \
  -d '{
    "location": "Barcelona, Spain",
    "interests": ["architecture", "food", "beaches"],
    "budget": "high",
    "duration": "5 days",
    "travelStyle": "luxury",
    "recommendationsChatflowId": "your-recommendations-chatflow-id",
    "culturalEtiquetteChatflowId": "your-cultural-etiquette-chatflow-id",
    "includeCulturalEtiquette": true
  }'
```

## Test 4: Simple Test Endpoint

### Request
```bash
curl -X POST http://localhost:3000/api/recommendations/test \
  -H "Content-Type: application/json" \
  -d '{
    "chatflowId": "your-recommendations-chatflow-id"
  }'
```

## Test 5: Health Check

### Request
```bash
curl -X GET http://localhost:3000/api/recommendations/health
```

### Expected Response
```json
{
  "success": true,
  "data": {...},
  "message": "Recommendations service is healthy"
}
```

## Test 6: Get Supported Interests

### Request
```bash
curl -X GET http://localhost:3000/api/recommendations/interests
```

### Expected Response
```json
{
  "success": true,
  "data": {
    "interests": [
      "culture", "history", "art", "music", "food", "nightlife",
      "adventure", "nature", "beaches", "mountains", "shopping",
      "architecture", "photography", "sports", "wellness",
      "family-friendly", "romantic", "business", "budget-travel",
      "luxury", "local-experiences", "festivals", "museums",
      "religious-sites", "outdoor-activities"
    ],
    "travelStyles": [
      "backpacker", "family", "business", "luxury", "tourist",
      "adventure", "cultural", "relaxation", "photography", "foodie"
    ],
    "budgetLevels": ["low", "medium", "high", "luxury"],
    "commonDurations": [
      "weekend", "3 days", "1 week", "2 weeks", "1 month", "long-term"
    ]
  },
  "message": "Supported interests and preferences retrieved successfully"
}
```

## Test 7: Error Handling - Missing Required Fields

### Request
```bash
curl -X POST http://localhost:3000/api/recommendations/personalized \
  -H "Content-Type: application/json" \
  -d '{
    "interests": ["culture", "food"]
  }'
```

### Expected Response
```json
{
  "success": false,
  "error": "Validation error",
  "message": "location is required",
  "details": [
    {
      "message": "location is required",
      "path": ["location"],
      "type": "any.required"
    }
  ]
}
```

## Test 8: Error Handling - Invalid Budget Level

### Request
```bash
curl -X POST http://localhost:3000/api/recommendations/personalized \
  -H "Content-Type: application/json" \
  -d '{
    "location": "Paris, France",
    "budget": "invalid-budget",
    "chatflowId": "your-chatflow-id"
  }'
```

### Expected Response
```json
{
  "success": false,
  "error": "Validation error",
  "message": "budget must be one of [low, medium, high, luxury]",
  "details": [
    {
      "message": "budget must be one of [low, medium, high, luxury]",
      "path": ["budget"],
      "type": "any.only"
    }
  ]
}
```

## Test 9: Different Travel Styles

### Backpacker Style
```bash
curl -X POST http://localhost:3000/api/recommendations/personalized \
  -H "Content-Type: application/json" \
  -d '{
    "location": "Thailand",
    "interests": ["adventure", "nature", "budget-travel"],
    "budget": "low",
    "travelStyle": "backpacker",
    "duration": "2 weeks",
    "chatflowId": "your-recommendations-chatflow-id"
  }'
```

### Family Style
```bash
curl -X POST http://localhost:3000/api/recommendations/personalized \
  -H "Content-Type: application/json" \
  -d '{
    "location": "Orlando, Florida",
    "interests": ["family-friendly", "theme-parks", "beaches"],
    "budget": "high",
    "travelStyle": "family",
    "duration": "1 week",
    "chatflowId": "your-recommendations-chatflow-id"
  }'
```

### Business Style
```bash
curl -X POST http://localhost:3000/api/recommendations/personalized \
  -H "Content-Type: application/json" \
  -d '{
    "location": "New York City, USA",
    "interests": ["business", "networking", "fine-dining"],
    "budget": "luxury",
    "travelStyle": "business",
    "duration": "3 days",
    "chatflowId": "your-recommendations-chatflow-id"
  }'
```

## Test 10: Different Budget Levels

### Low Budget
```bash
curl -X POST http://localhost:3000/api/recommendations/personalized \
  -H "Content-Type: application/json" \
  -d '{
    "location": "Prague, Czech Republic",
    "interests": ["culture", "history", "budget-travel"],
    "budget": "low",
    "chatflowId": "your-recommendations-chatflow-id"
  }'
```

### High Budget
```bash
curl -X POST http://localhost:3000/api/recommendations/personalized \
  -H "Content-Type: application/json" \
  -d '{
    "location": "Dubai, UAE",
    "interests": ["luxury", "shopping", "fine-dining"],
    "budget": "luxury",
    "chatflowId": "your-recommendations-chatflow-id"
  }'
```

## Test 11: Dietary Restrictions

### Vegetarian
```bash
curl -X POST http://localhost:3000/api/recommendations/personalized \
  -H "Content-Type: application/json" \
  -d '{
    "location": "India",
    "interests": ["food", "culture", "spiritual"],
    "budget": "medium",
    "dietaryRestrictions": ["vegetarian"],
    "chatflowId": "your-recommendations-chatflow-id"
  }'
```

### Gluten-Free
```bash
curl -X POST http://localhost:3000/api/recommendations/personalized \
  -H "Content-Type: application/json" \
  -d '{
    "location": "Italy",
    "interests": ["food", "culture", "history"],
    "budget": "medium",
    "dietaryRestrictions": ["gluten-free"],
    "chatflowId": "your-recommendations-chatflow-id"
  }'
```

## Test 12: Different Durations

### Weekend Trip
```bash
curl -X POST http://localhost:3000/api/recommendations/personalized \
  -H "Content-Type: application/json" \
  -d '{
    "location": "Amsterdam, Netherlands",
    "interests": ["culture", "nightlife", "canals"],
    "budget": "medium",
    "duration": "weekend",
    "chatflowId": "your-recommendations-chatflow-id"
  }'
```

### Long-term Travel
```bash
curl -X POST http://localhost:3000/api/recommendations/personalized \
  -H "Content-Type: application/json" \
  -d '{
    "location": "Southeast Asia",
    "interests": ["adventure", "culture", "nature"],
    "budget": "low",
    "duration": "3 months",
    "travelStyle": "backpacker",
    "chatflowId": "your-recommendations-chatflow-id"
  }'
```

## Test 13: Cultural Etiquette for Different Regions

### Middle East
```bash
curl -X POST http://localhost:3000/api/recommendations/cultural-etiquette \
  -H "Content-Type: application/json" \
  -d '{
    "location": "Dubai, UAE",
    "chatflowId": "your-cultural-etiquette-chatflow-id",
    "specificTopics": ["dining", "dress-code", "business"]
  }'
```

### Asia
```bash
curl -X POST http://localhost:3000/api/recommendations/cultural-etiquette \
  -H "Content-Type: application/json" \
  -d '{
    "location": "South Korea",
    "chatflowId": "your-cultural-etiquette-chatflow-id",
    "specificTopics": ["dining", "greetings", "gift-giving"]
  }'
```

### Europe
```bash
curl -X POST http://localhost:3000/api/recommendations/cultural-etiquette \
  -H "Content-Type: application/json" \
  -d '{
    "location": "Germany",
    "chatflowId": "your-cultural-etiquette-chatflow-id",
    "specificTopics": ["business", "dining", "punctuality"]
  }'
```

## Test 14: Complex Preferences

### Request with Complex Preferences
```bash
curl -X POST http://localhost:3000/api/recommendations/personalized \
  -H "Content-Type: application/json" \
  -d '{
    "location": "San Francisco, USA",
    "interests": ["technology", "food", "outdoor-activities"],
    "budget": "high",
    "preferences": {
      "avoidCrowds": true,
      "preferLocal": true,
      "sustainableTravel": true,
      "accessibility": "wheelchair-accessible"
    },
    "duration": "1 week",
    "travelStyle": "business",
    "dietaryRestrictions": ["vegetarian", "gluten-free"],
    "chatflowId": "your-recommendations-chatflow-id"
  }'
```

## Test 15: API Root Endpoint

### Request
```bash
curl -X GET http://localhost:3000/
```

### Expected Response
```json
{
  "message": "AI Travel Assistant API",
  "version": "1.0.0",
  "status": "running",
  "endpoints": {
    "translation": "/api/translation",
    "transportation": "/api/transportation",
    "recommendations": "/api/recommendations",
    "personalizedRecommendations": "/api/recommendations/personalized",
    "culturalEtiquette": "/api/recommendations/cultural-etiquette",
    "comprehensiveRecommendations": "/api/recommendations/comprehensive",
    "recommendationsTest": "/api/recommendations/test",
    "recommendationsHealth": "/api/recommendations/health",
    "recommendationsInterests": "/api/recommendations/interests"
  },
  "quickTest": {
    "translation": {...},
    "recommendations": {...}
  }
}
```

## Postman Collection

You can also test these endpoints using Postman. Import the following collection:

```json
{
  "info": {
    "name": "Recommendations API Tests",
    "description": "Test collection for Personalized Recommendations API"
  },
  "item": [
    {
      "name": "Personalized Recommendations",
      "request": {
        "method": "POST",
        "header": [
          {
            "key": "Content-Type",
            "value": "application/json"
          }
        ],
        "body": {
          "mode": "raw",
          "raw": "{\n  \"location\": \"Paris, France\",\n  \"interests\": [\"culture\", \"food\", \"art\"],\n  \"budget\": \"medium\",\n  \"chatflowId\": \"your-chatflow-id\"\n}"
        },
        "url": {
          "raw": "http://localhost:3000/api/recommendations/personalized",
          "protocol": "http",
          "host": ["localhost"],
          "port": "3000",
          "path": ["api", "recommendations", "personalized"]
        }
      }
    }
  ]
}
```

## Notes

1. Replace `your-recommendations-chatflow-id` and `your-cultural-etiquette-chatflow-id` with your actual Flowise agent flow IDs
2. All tests assume the server is running on `localhost:3000`
3. Some tests may return different results based on your Flowise agent configurations
4. Ensure your environment variables are properly set before running tests
5. Check the console logs for detailed request/response information during testing
