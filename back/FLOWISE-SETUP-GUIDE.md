# Flowise Agent Setup Guide for Personalized Recommendations

This guide will help you set up your Flowise agent flows to work with the Personalized Recommendations API.

## Prerequisites

1. **Flowise Account**: You need access to Flowise Cloud or a self-hosted Flowise instance
2. **API Key**: Your Flowise API key
3. **Agent Flow ID**: `32547d3e-ba39-4604-a904-da0c516e17b1` (your provided ID)

## Environment Setup

### 1. Create .env file

Create a `.env` file in your project root with the following variables:

```bash
# Flowise Configuration
FLOWISE_API_URL=https://cloud.flowiseai.com
FLOWISE_API_KEY=your_flowise_api_key_here

# Server Configuration
PORT=3000
NODE_ENV=development
```

### 2. Get Your Flowise API Key

1. Log into your Flowise account
2. Go to Settings → API Keys
3. Create a new API key or copy an existing one
4. Add it to your `.env` file

## Flowise Agent Configuration

### Agent 1: Personalized Recommendations

Your Flowise agent should be configured to handle travel recommendations. Here's the recommended setup:

#### Input Parameters
The agent should accept these parameters:
- `location`: Destination location (e.g., "Paris, France")
- `interests`: Array of interests (e.g., ["culture", "food", "art"])
- `budget`: Budget level ("low", "medium", "high", "luxury")
- `duration`: Trip duration (e.g., "1 week", "weekend")
- `travelStyle`: Travel style (e.g., "tourist", "backpacker", "family")

#### Expected Output Format
The agent should return structured JSON with:

```json
{
  "attractions": [
    {
      "name": "Attraction Name",
      "type": "museum|restaurant|activity|landmark|entertainment",
      "description": "Brief description",
      "budgetLevel": "low|medium|high|luxury",
      "estimatedCost": "Cost range or free",
      "duration": "Time needed to visit",
      "bestTimeToVisit": "When to go",
      "whyRecommended": "Why this fits the user's interests"
    }
  ],
  "restaurants": [
    {
      "name": "Restaurant Name",
      "cuisine": "Type of cuisine",
      "priceRange": "$|$$|$$$|$$$$",
      "description": "What makes it special",
      "dietaryFriendly": "Vegetarian/Vegan/Gluten-free options",
      "location": "Area/neighborhood",
      "whyRecommended": "Why this fits the user's preferences"
    }
  ],
  "activities": [
    {
      "name": "Activity Name",
      "type": "outdoor|indoor|cultural|adventure|relaxation",
      "description": "What the activity involves",
      "budgetLevel": "low|medium|high|luxury",
      "estimatedCost": "Cost range",
      "duration": "How long it takes",
      "bestTimeToDo": "When to do this activity",
      "whyRecommended": "Why this fits the user's interests"
    }
  ],
  "itinerary": {
    "day1": "Suggested activities for first day",
    "day2": "Suggested activities for second day",
    "day3": "Suggested activities for third day"
  },
  "tips": [
    "Practical travel tips for this destination",
    "Money-saving tips",
    "Safety considerations"
  ]
}
```

#### Recommended Flowise Nodes

1. **Chat Input Node**: To receive the user's question
2. **LLM Chain Node**: Configure with your preferred LLM (GPT-4, Claude, etc.)
3. **Prompt Template Node**: Create a comprehensive prompt for travel recommendations
4. **Output Node**: Return the structured response

#### Sample Prompt Template

```
You are a professional travel advisor. Provide personalized recommendations for a trip to {location}.

**Trip Details:**
- Location: {location}
- Duration: {duration}
- Travel Style: {travelStyle}
- Budget Level: {budget}
- Interests: {interests}

**Please provide recommendations in the following JSON format:**
{
  "attractions": [
    {
      "name": "Attraction Name",
      "type": "museum|restaurant|activity|landmark|entertainment",
      "description": "Brief description",
      "budgetLevel": "low|medium|high|luxury",
      "estimatedCost": "Cost range or free",
      "duration": "Time needed to visit",
      "bestTimeToVisit": "When to go",
      "whyRecommended": "Why this fits the user's interests"
    }
  ],
  "restaurants": [
    {
      "name": "Restaurant Name",
      "cuisine": "Type of cuisine",
      "priceRange": "$|$$|$$$|$$$$",
      "description": "What makes it special",
      "dietaryFriendly": "Vegetarian/Vegan/Gluten-free options",
      "location": "Area/neighborhood",
      "whyRecommended": "Why this fits the user's preferences"
    }
  ],
  "activities": [
    {
      "name": "Activity Name",
      "type": "outdoor|indoor|cultural|adventure|relaxation",
      "description": "What the activity involves",
      "budgetLevel": "low|medium|high|luxury",
      "estimatedCost": "Cost range",
      "duration": "How long it takes",
      "bestTimeToDo": "When to do this activity",
      "whyRecommended": "Why this fits the user's interests"
    }
  ],
  "itinerary": {
    "day1": "Suggested activities for first day",
    "day2": "Suggested activities for second day",
    "day3": "Suggested activities for third day"
  },
  "tips": [
    "Practical travel tips for this destination",
    "Money-saving tips",
    "Safety considerations"
  ]
}

Focus on providing practical, actionable recommendations that match the user's budget, interests, and travel style. Include both popular attractions and hidden gems.
```

### Agent 2: Cultural Etiquette (Optional)

For cultural etiquette information, create a second Flowise agent with this configuration:

#### Input Parameters
- `location`: Destination location
- `specificTopics`: Array of specific cultural topics (optional)

#### Expected Output Format

```json
{
  "generalEtiquette": {
    "greetings": "How to greet people properly",
    "dressCode": "Appropriate clothing and dress codes",
    "bodyLanguage": "Important body language and gestures",
    "personalSpace": "Personal space and physical contact norms"
  },
  "diningEtiquette": {
    "tableManners": "Proper table manners and dining customs",
    "tipping": "Tipping customs and expectations",
    "diningTimes": "Typical meal times and dining culture",
    "foodCustoms": "Special food-related customs and traditions"
  },
  "socialEtiquette": {
    "conversation": "Conversation topics and taboos",
    "giftGiving": "Gift giving customs and traditions",
    "businessEtiquette": "Business meeting and professional customs",
    "religiousConsiderations": "Religious customs and considerations"
  },
  "dosAndDonts": {
    "dos": [
      "Things you should do in this culture",
      "Positive behaviors to adopt"
    ],
    "donts": [
      "Things you should avoid doing",
      "Behaviors that are considered rude or offensive"
    ]
  },
  "languageTips": {
    "commonPhrases": ["Useful local phrases", "Greetings", "Thank you", "Please", "Excuse me"],
    "pronunciation": "Pronunciation tips for common words",
    "formality": "Formal vs informal language usage"
  },
  "culturalNorms": {
    "timePunctuality": "Attitudes towards time and punctuality",
    "familyValues": "Family and social structure importance",
    "hierarchy": "Social hierarchy and respect customs",
    "celebrations": "Important celebrations and holidays"
  }
}
```

## Testing Your Setup

### 1. Test Environment Variables

Create a test file `test-env.js`:

```javascript
require('dotenv').config();

console.log('Environment Variables:');
console.log('FLOWISE_API_URL:', process.env.FLOWISE_API_URL);
console.log('FLOWISE_API_KEY:', process.env.FLOWISE_API_KEY ? 'Set' : 'Not Set');
console.log('PORT:', process.env.PORT);
```

Run it with: `node test-env.js`

### 2. Test Flowise Connection

Use the provided `test-flowise-integration.js` file:

```bash
node test-flowise-integration.js
```

### 3. Test API Endpoints

Once your environment is set up, test the API:

```bash
# Test health check
Invoke-WebRequest -Uri "http://localhost:3000/api/recommendations/health" -Method GET

# Test interests endpoint
Invoke-WebRequest -Uri "http://localhost:3000/api/recommendations/interests" -Method GET

# Test recommendations (replace with your actual chatflow ID)
Invoke-WebRequest -Uri "http://localhost:3000/api/recommendations/test" -Method POST -ContentType "application/json" -Body '{"chatflowId": "32547d3e-ba39-4604-a904-da0c516e17b1"}'
```

## Troubleshooting

### Common Issues

1. **"Cannot read properties of undefined (reading 'filePath')"**
   - This usually means there's a misconfigured node in your Flowise flow
   - Check for any file-related nodes that might be missing configuration
   - Ensure all nodes are properly connected

2. **"API Key not configured"**
   - Make sure your `.env` file is in the project root
   - Verify the API key is correct
   - Restart the server after adding environment variables

3. **"Chatflow not found"**
   - Verify the chatflow ID is correct
   - Make sure the chatflow is published and active
   - Check if you have access to the chatflow

4. **Timeout errors**
   - Increase the timeout in the service configuration
   - Check if your Flowise instance is responsive
   - Verify your internet connection

### Debug Steps

1. **Check Flowise Flow Status**
   - Log into Flowise
   - Verify your flow is published and active
   - Test the flow directly in Flowise interface

2. **Test with Simple Messages**
   - Start with basic text input
   - Gradually add complexity
   - Check Flowise logs for errors

3. **Verify API Configuration**
   - Check your API key permissions
   - Verify the API URL is correct
   - Test with Flowise's built-in API tester

## Next Steps

1. **Set up your environment variables** in the `.env` file
2. **Configure your Flowise agent** with the recommended prompt template
3. **Test the integration** using the provided test scripts
4. **Deploy and use** the API in your application

## Support

If you encounter issues:

1. Check the Flowise documentation
2. Verify your agent configuration
3. Test with simple inputs first
4. Check the server logs for detailed error messages

The API is now ready to use once your Flowise agent is properly configured!
