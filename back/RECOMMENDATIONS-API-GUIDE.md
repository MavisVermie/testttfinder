# Personalized Recommendations API Guide

This guide explains how to use the new Personalized Recommendations API that integrates with your Flowise agent flows to provide intelligent travel recommendations and cultural etiquette information.

## Overview

The Recommendations API provides three main functionalities:
1. **Personalized Recommendations** - AI-powered suggestions for attractions, restaurants, and activities
2. **Cultural Etiquette** - Do's and don'ts, cultural norms, and etiquette guidelines
3. **Comprehensive Recommendations** - Combined recommendations and cultural etiquette

## Setup

### Environment Variables

Make sure you have the following environment variables configured:

```bash
FLOWISE_API_URL=https://cloud.flowiseai.com  # or your Flowise instance URL
FLOWISE_API_KEY=your_flowise_api_key_here
```

### Flowise Agent Flows

You'll need to create two separate Flowise agent flows:

1. **Recommendations Flow** - For generating personalized travel recommendations
2. **Cultural Etiquette Flow** - For providing cultural etiquette information

## API Endpoints

### 1. Personalized Recommendations

**Endpoint:** `POST /api/recommendations/personalized`

Get personalized travel recommendations based on location, interests, budget, and preferences.

#### Request Body

```json
{
  "location": "Paris, France",
  "interests": ["culture", "food", "art"],
  "budget": "medium",
  "preferences": {
    "avoidCrowds": true,
    "preferLocal": true
  },
  "duration": "1 week",
  "travelStyle": "tourist",
  "dietaryRestrictions": ["vegetarian"],
  "chatflowId": "your-recommendations-chatflow-id"
}
```

#### Parameters

- `location` (required): Destination location
- `interests` (optional): Array of interests (culture, food, art, adventure, etc.)
- `budget` (optional): Budget level - "low", "medium", "high", "luxury"
- `preferences` (optional): Additional preferences object
- `duration` (optional): Trip duration (e.g., "weekend", "1 week", "2 weeks")
- `travelStyle` (optional): Travel style - "backpacker", "family", "business", "luxury", "tourist", "adventure"
- `dietaryRestrictions` (optional): Array of dietary restrictions
- `chatflowId` (required): Your Flowise recommendations chatflow ID

#### Response

```json
{
  "success": true,
  "data": {
    "recommendations": {
      "attractions": [
        {
          "name": "Louvre Museum",
          "type": "museum",
          "description": "World's largest art museum",
          "budgetLevel": "medium",
          "estimatedCost": "€15-20",
          "duration": "3-4 hours",
          "bestTimeToVisit": "Early morning or late afternoon",
          "whyRecommended": "Perfect for art and culture enthusiasts"
        }
      ],
      "restaurants": [
        {
          "name": "Le Comptoir du Relais",
          "cuisine": "French Bistro",
          "priceRange": "$$",
          "description": "Authentic Parisian bistro experience",
          "dietaryFriendly": "Vegetarian options available",
          "location": "Saint-Germain-des-Prés",
          "whyRecommended": "Local favorite with excellent vegetarian dishes"
        }
      ],
      "activities": [
        {
          "name": "Seine River Cruise",
          "type": "sightseeing",
          "description": "Scenic boat tour along the Seine",
          "budgetLevel": "medium",
          "estimatedCost": "€15-25",
          "duration": "1 hour",
          "bestTimeToDo": "Evening for sunset views",
          "whyRecommended": "Great way to see Paris landmarks"
        }
      ],
      "itinerary": {
        "day1": "Louvre Museum → Seine Cruise → Le Comptoir du Relais",
        "day2": "Eiffel Tower → Montmartre → Local café",
        "day3": "Notre-Dame → Latin Quarter → Art galleries"
      },
      "tips": [
        "Book museum tickets in advance",
        "Use public transport for cost savings",
        "Try local markets for authentic food"
      ]
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

### 2. Cultural Etiquette

**Endpoint:** `POST /api/recommendations/cultural-etiquette`

Get cultural etiquette information for a specific location.

#### Request Body

```json
{
  "location": "Tokyo, Japan",
  "chatflowId": "your-cultural-etiquette-chatflow-id",
  "specificTopics": ["dining", "business", "greetings"]
}
```

#### Parameters

- `location` (required): Destination location
- `chatflowId` (required): Your Flowise cultural etiquette chatflow ID
- `specificTopics` (optional): Array of specific cultural topics to focus on

#### Response

```json
{
  "success": true,
  "data": {
    "culturalEtiquette": {
      "generalEtiquette": {
        "greetings": "Bow when greeting, avoid physical contact",
        "dressCode": "Conservative dress, remove shoes indoors",
        "bodyLanguage": "Avoid pointing, maintain respectful posture",
        "personalSpace": "Respect personal space, avoid loud conversations"
      },
      "diningEtiquette": {
        "tableManners": "Use chopsticks properly, don't stick them upright in rice",
        "tipping": "Tipping is not customary and may be considered rude",
        "diningTimes": "Dinner typically 6-8 PM, lunch 12-2 PM",
        "foodCustoms": "Say 'itadakimasu' before eating, 'gochisousama' after"
      },
      "socialEtiquette": {
        "conversation": "Avoid personal questions, discuss weather or food",
        "giftGiving": "Present gifts with both hands, avoid white flowers",
        "businessEtiquette": "Exchange business cards with both hands, bow slightly",
        "religiousConsiderations": "Remove shoes in temples, be quiet and respectful"
      },
      "dosAndDonts": {
        "dos": [
          "Bow when greeting",
          "Remove shoes indoors",
          "Use both hands when giving/receiving",
          "Be punctual for appointments"
        ],
        "donts": [
          "Don't point with your finger",
          "Don't eat or drink while walking",
          "Don't blow your nose in public",
          "Don't tip at restaurants"
        ]
      },
      "languageTips": {
        "commonPhrases": ["Konnichiwa (Hello)", "Arigato (Thank you)", "Sumimasen (Excuse me)"],
        "pronunciation": "Pronounce each syllable clearly",
        "formality": "Use polite forms (-masu, -desu) with strangers"
      },
      "culturalNorms": {
        "timePunctuality": "Extremely important, arrive 5-10 minutes early",
        "familyValues": "Family is highly respected, elders are honored",
        "hierarchy": "Age and status matter, show respect to seniors",
        "celebrations": "Cherry blossom season, New Year are major celebrations"
      }
    },
    "metadata": {
      "location": "Tokyo, Japan",
      "specificTopics": ["dining", "business", "greetings"],
      "timestamp": "2024-01-15T10:30:00.000Z"
    }
  },
  "message": "Cultural etiquette information retrieved successfully"
}
```

### 3. Comprehensive Recommendations

**Endpoint:** `POST /api/recommendations/comprehensive`

Get both personalized recommendations and cultural etiquette in one request.

#### Request Body

```json
{
  "location": "Barcelona, Spain",
  "interests": ["architecture", "food", "beaches"],
  "budget": "high",
  "duration": "5 days",
  "travelStyle": "luxury",
  "recommendationsChatflowId": "your-recommendations-chatflow-id",
  "culturalEtiquetteChatflowId": "your-cultural-etiquette-chatflow-id",
  "includeCulturalEtiquette": true
}
```

#### Response

```json
{
  "success": true,
  "data": {
    "recommendations": {
      // ... personalized recommendations data
    },
    "culturalEtiquette": {
      // ... cultural etiquette data
    },
    "metadata": {
      "location": "Barcelona, Spain",
      "interests": ["architecture", "food", "beaches"],
      "budget": "high",
      "duration": "5 days",
      "travelStyle": "luxury",
      "timestamp": "2024-01-15T10:30:00.000Z"
    }
  },
  "message": "Comprehensive travel recommendations generated successfully"
}
```

### 4. Test Endpoint

**Endpoint:** `POST /api/recommendations/test`

Simple test endpoint with default values.

#### Request Body

```json
{
  "chatflowId": "your-recommendations-chatflow-id"
}
```

### 5. Health Check

**Endpoint:** `GET /api/recommendations/health`

Check if the recommendations service is working properly.

### 6. Supported Interests

**Endpoint:** `GET /api/recommendations/interests`

Get list of supported interests, travel styles, and budget levels.

## Testing with Postman

### 1. Test Personalized Recommendations

```bash
POST http://localhost:3000/api/recommendations/test
Content-Type: application/json

{
  "chatflowId": "your-recommendations-chatflow-id"
}
```

### 2. Test Cultural Etiquette

```bash
POST http://localhost:3000/api/recommendations/cultural-etiquette
Content-Type: application/json

{
  "location": "Paris, France",
  "chatflowId": "your-cultural-etiquette-chatflow-id"
}
```

### 3. Test Comprehensive Recommendations

```bash
POST http://localhost:3000/api/recommendations/comprehensive
Content-Type: application/json

{
  "location": "Rome, Italy",
  "interests": ["history", "food", "art"],
  "budget": "medium",
  "recommendationsChatflowId": "your-recommendations-chatflow-id",
  "culturalEtiquetteChatflowId": "your-cultural-etiquette-chatflow-id"
}
```

## Flowise Agent Setup

### Recommendations Agent

Your Flowise agent for recommendations should be configured to:
1. Accept location, interests, budget, and preferences as input
2. Generate structured JSON responses with attractions, restaurants, activities, and itinerary
3. Consider cultural context and local knowledge
4. Provide practical, actionable recommendations

### Cultural Etiquette Agent

Your Flowise agent for cultural etiquette should be configured to:
1. Accept location and specific topics as input
2. Generate structured JSON responses with cultural norms and etiquette rules
3. Focus on practical do's and don'ts
4. Include language tips and cultural context

## Error Handling

The API includes comprehensive error handling:

- **400 Bad Request**: Invalid input parameters
- **500 Internal Server Error**: Server-side errors
- **Flowise API Errors**: Errors from your Flowise agents

Example error response:

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

## Best Practices

1. **Use specific locations**: "Paris, France" works better than just "Paris"
2. **Be specific with interests**: Use the supported interests list
3. **Set realistic budgets**: Match your actual budget level
4. **Include dietary restrictions**: For better restaurant recommendations
5. **Test with different chatflow IDs**: Ensure your Flowise agents are properly configured

## Integration Examples

### Frontend Integration

```javascript
// Get personalized recommendations
const getRecommendations = async (location, interests, budget, chatflowId) => {
  const response = await fetch('/api/recommendations/personalized', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      location,
      interests,
      budget,
      chatflowId
    })
  });
  
  return await response.json();
};

// Get cultural etiquette
const getCulturalEtiquette = async (location, chatflowId) => {
  const response = await fetch('/api/recommendations/cultural-etiquette', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      location,
      chatflowId
    })
  });
  
  return await response.json();
};
```

### Backend Integration

```javascript
const RecommendationsService = require('./services/recommendationsService');
const recommendationsService = new RecommendationsService();

// Get recommendations
const result = await recommendationsService.getPersonalizedRecommendations({
  location: 'Tokyo, Japan',
  interests: ['culture', 'food'],
  budget: 'medium',
  chatflowId: 'your-chatflow-id'
});
```

## Troubleshooting

### Common Issues

1. **Flowise API Key not configured**: Check your environment variables
2. **Invalid chatflow ID**: Verify your Flowise agent flow IDs
3. **Timeout errors**: Increase timeout in service configuration
4. **JSON parsing errors**: Ensure your Flowise agents return valid JSON

### Debug Mode

Enable debug logging by checking the console output for detailed request/response information.

## Support

For issues or questions:
1. Check the console logs for detailed error messages
2. Verify your Flowise agent configurations
3. Test with the provided test endpoints
4. Ensure all required parameters are provided
