# Currency Conversion API Test Guide

This guide provides comprehensive testing instructions for the Currency Conversion API using your Flowise AI ID: `8a5ceb67-167b-474d-83dc-adcac6579aae`

## Prerequisites

1. Ensure your `.env` file contains:
   ```
   FLOWISE_API_KEY=your_flowise_api_key_here
   FLOWISE_API_URL=https://cloud.flowiseai.com
   ```

2. Start the server:
   ```bash
   npm start
   ```

## API Endpoints

### 1. Currency Conversion
**POST** `/api/currency/convert`

Convert an amount from one currency to another.

**Request Body:**
```json
{
  "amount": 100,
  "fromCurrency": "USD",
  "toCurrency": "EUR"
}
```

**Example cURL:**
```bash
curl -X POST http://localhost:3000/api/currency/convert \
  -H "Content-Type: application/json" \
  -d '{
    "amount": 100,
    "fromCurrency": "USD",
    "toCurrency": "EUR"
  }'
```

### 2. Exchange Rates
**POST** `/api/currency/exchange-rates`

Get exchange rates for multiple currencies.

**Request Body:**
```json
{
  "baseCurrency": "USD",
  "targetCurrencies": ["EUR", "GBP", "JPY", "CAD"]
}
```

**Example cURL:**
```bash
curl -X POST http://localhost:3000/api/currency/exchange-rates \
  -H "Content-Type: application/json" \
  -d '{
    "baseCurrency": "USD",
    "targetCurrencies": ["EUR", "GBP", "JPY"]
  }'
```

### 3. Currency Information
**GET** `/api/currency/info/:currency`

Get detailed information about a specific currency.

**Example cURL:**
```bash
curl -X GET http://localhost:3000/api/currency/info/USD
```

### 4. Supported Currencies
**GET** `/api/currency/supported`

Get list of all supported currency codes.

**Example cURL:**
```bash
curl -X GET http://localhost:3000/api/currency/supported
```

### 5. Health Check
**GET** `/api/currency/health`

Check the health status of the currency service.

**Example cURL:**
```bash
curl -X GET http://localhost:3000/api/currency/health
```

### 6. Test Endpoint
**POST** `/api/currency/test`

Test the currency conversion with sample data.

**Example cURL:**
```bash
curl -X POST http://localhost:3000/api/currency/test
```

### 7. Service Information
**GET** `/api/currency`

Get information about the currency service and available endpoints.

**Example cURL:**
```bash
curl -X GET http://localhost:3000/api/currency
```

## Test Scenarios

### Scenario 1: Basic Currency Conversion
Test converting common currencies:

```bash
# USD to EUR
curl -X POST http://localhost:3000/api/currency/convert \
  -H "Content-Type: application/json" \
  -d '{"amount": 100, "fromCurrency": "USD", "toCurrency": "EUR"}'

# EUR to GBP
curl -X POST http://localhost:3000/api/currency/convert \
  -H "Content-Type: application/json" \
  -d '{"amount": 50, "fromCurrency": "EUR", "toCurrency": "GBP"}'

# JPY to USD
curl -X POST http://localhost:3000/api/currency/convert \
  -H "Content-Type: application/json" \
  -d '{"amount": 10000, "fromCurrency": "JPY", "toCurrency": "USD"}'
```

### Scenario 2: Exchange Rates
Test getting exchange rates:

```bash
# Get USD rates for major currencies
curl -X POST http://localhost:3000/api/currency/exchange-rates \
  -H "Content-Type: application/json" \
  -d '{
    "baseCurrency": "USD",
    "targetCurrencies": ["EUR", "GBP", "JPY", "CAD", "AUD", "CHF"]
  }'

# Get EUR rates
curl -X POST http://localhost:3000/api/currency/exchange-rates \
  -H "Content-Type: application/json" \
  -d '{
    "baseCurrency": "EUR",
    "targetCurrencies": ["USD", "GBP", "JPY"]
  }'
```

### Scenario 3: Currency Information
Test getting currency information:

```bash
# Get USD information
curl -X GET http://localhost:3000/api/currency/info/USD

# Get EUR information
curl -X GET http://localhost:3000/api/currency/info/EUR

# Get GBP information
curl -X GET http://localhost:3000/api/currency/info/GBP
```

### Scenario 4: Error Handling
Test error scenarios:

```bash
# Invalid amount
curl -X POST http://localhost:3000/api/currency/convert \
  -H "Content-Type: application/json" \
  -d '{"amount": -100, "fromCurrency": "USD", "toCurrency": "EUR"}'

# Invalid currency code
curl -X POST http://localhost:3000/api/currency/convert \
  -H "Content-Type: application/json" \
  -d '{"amount": 100, "fromCurrency": "INVALID", "toCurrency": "EUR"}'

# Same source and target currency
curl -X POST http://localhost:3000/api/currency/convert \
  -H "Content-Type: application/json" \
  -d '{"amount": 100, "fromCurrency": "USD", "toCurrency": "USD"}'
```

## Expected Responses

### Successful Conversion Response:
```json
{
  "success": true,
  "message": "Currency conversion completed successfully",
  "data": {
    "originalAmount": 100,
    "fromCurrency": "USD",
    "toCurrency": "EUR",
    "aiResponse": "100 USD is approximately 85.50 EUR...",
    "rawResponse": { ... },
    "timestamp": "2024-01-15T10:30:00.000Z"
  }
}
```

### Error Response:
```json
{
  "success": false,
  "error": "Validation error",
  "details": ["Amount must be a positive number"]
}
```

## Testing with Postman

1. Import the following collection into Postman:

```json
{
  "info": {
    "name": "Currency Conversion API",
    "schema": "https://schema.getpostman.com/json/collection/v2.1.0/collection.json"
  },
  "item": [
    {
      "name": "Convert Currency",
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
          "raw": "{\n  \"amount\": 100,\n  \"fromCurrency\": \"USD\",\n  \"toCurrency\": \"EUR\"\n}"
        },
        "url": {
          "raw": "http://localhost:3000/api/currency/convert",
          "protocol": "http",
          "host": ["localhost"],
          "port": "3000",
          "path": ["api", "currency", "convert"]
        }
      }
    },
    {
      "name": "Get Exchange Rates",
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
          "raw": "{\n  \"baseCurrency\": \"USD\",\n  \"targetCurrencies\": [\"EUR\", \"GBP\", \"JPY\"]\n}"
        },
        "url": {
          "raw": "http://localhost:3000/api/currency/exchange-rates",
          "protocol": "http",
          "host": ["localhost"],
          "port": "3000",
          "path": ["api", "currency", "exchange-rates"]
        }
      }
    },
    {
      "name": "Get Currency Info",
      "request": {
        "method": "GET",
        "url": {
          "raw": "http://localhost:3000/api/currency/info/USD",
          "protocol": "http",
          "host": ["localhost"],
          "port": "3000",
          "path": ["api", "currency", "info", "USD"]
        }
      }
    },
    {
      "name": "Get Supported Currencies",
      "request": {
        "method": "GET",
        "url": {
          "raw": "http://localhost:3000/api/currency/supported",
          "protocol": "http",
          "host": ["localhost"],
          "port": "3000",
          "path": ["api", "currency", "supported"]
        }
      }
    },
    {
      "name": "Health Check",
      "request": {
        "method": "GET",
        "url": {
          "raw": "http://localhost:3000/api/currency/health",
          "protocol": "http",
          "host": ["localhost"],
          "port": "3000",
          "path": ["api", "currency", "health"]
        }
      }
    },
    {
      "name": "Test Endpoint",
      "request": {
        "method": "POST",
        "url": {
          "raw": "http://localhost:3000/api/currency/test",
          "protocol": "http",
          "host": ["localhost"],
          "port": "3000",
          "path": ["api", "currency", "test"]
        }
      }
    }
  ]
}
```

## Troubleshooting

### Common Issues:

1. **Flowise API Key Error**: Ensure your `.env` file has the correct `FLOWISE_API_KEY`
2. **Invalid Currency Code**: Use 3-letter currency codes (e.g., USD, EUR, GBP)
3. **Amount Validation**: Amount must be a positive number
4. **Network Issues**: Check your internet connection and Flowise service status

### Debug Steps:

1. Check server logs for detailed error messages
2. Verify Flowise AI ID is correct: `8a5ceb67-167b-474d-83dc-adcac6579aae`
3. Test with the health check endpoint first
4. Use the test endpoint to verify basic functionality

## Performance Notes

- The API uses a 30-second timeout for Flowise requests
- Rate limiting is applied (100 requests per 15 minutes per IP)
- All responses include timestamps for tracking
- AI responses are cached in the response for debugging

## Security Features

- Input validation using Joi schemas
- Rate limiting to prevent abuse
- CORS protection
- Helmet security headers
- Request size limits (10MB max)
