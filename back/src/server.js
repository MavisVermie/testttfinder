const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const morgan = require('morgan');
const compression = require('compression');
const rateLimit = require('express-rate-limit');
require('dotenv').config();

const translationRoutes = require('./routes/translation');
const transportationRoutes = require('./routes/transportation');
const recommendationsRoutes = require('./routes/recommendations');
const scamPreventionRoutes = require('./routes/scamPrevention');
const currencyRoutes = require('./routes/currency');

const app = express();
const PORT = process.env.PORT || 3000;

/* ----------------------------- Security & Ops ----------------------------- */

// Security headers
app.use(helmet());

// CORS
app.use(
  cors({
    origin:
      process.env.NODE_ENV === 'production'
        ? ['https://your-frontend-domain.com']
        : ['http://localhost:3000', 'http://localhost:3001'],
    credentials: true,
  })
);

// Rate limiting
const limiter = rateLimit({
  windowMs:
    parseInt(process.env.RATE_LIMIT_WINDOW_MS, 10) || 15 * 60 * 1000, // 15 min
  max: parseInt(process.env.RATE_LIMIT_MAX_REQUESTS, 10) || 100,
  message: {
    error: 'Too many requests from this IP, please try again later.',
    retryAfter: Math.ceil(
      (parseInt(process.env.RATE_LIMIT_WINDOW_MS, 10) || 15 * 60 * 1000) / 1000
    ),
  },
});
app.use(limiter);

// Parsers & compression
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true, limit: '10mb' }));
app.use(compression());

// Logging
app.use(morgan(process.env.NODE_ENV === 'production' ? 'combined' : 'dev'));

/* --------------------------------- Routes -------------------------------- */

app.use('/api/translation', translationRoutes);
app.use('/api/transportation', transportationRoutes);
app.use('/api/recommendations', recommendationsRoutes);
app.use('/api/scam-prevention', scamPreventionRoutes);
app.use('/api/currency', currencyRoutes);

/* ------------------------------- Root Index ------------------------------- */

app.get('/', (req, res) => {
  res.json({
    message: 'AI Travel Assistant API',
    version: '1.0.0',
    status: 'running',
    endpoints: {
      // Translation
      translation: '/api/translation',
      test: '/api/translation/test',
      languages: '/api/translation/languages',
      chatflows: '/api/translation/chatflows',

      // Transportation
      transportation: '/api/transportation',
      transportationOptions: '/api/transportation/options',
      transportationRealtime: '/api/transportation/realtime',
      transportationDirections: '/api/transportation/directions',
      transportationStatus: '/api/transportation/status',
      transportationHelp: '/api/transportation/help',

      // Recommendations
      recommendations: '/api/recommendations',
      personalizedRecommendations: '/api/recommendations/personalized',
      culturalEtiquette: '/api/recommendations/cultural-etiquette',
      comprehensiveRecommendations: '/api/recommendations/comprehensive',
      recommendationsTest: '/api/recommendations/test',
      recommendationsHealth: '/api/recommendations/health',
      recommendationsInterests: '/api/recommendations/interests',

      // Scam Prevention
      scamPrevention: '/api/scam-prevention',
      priceAdvice: '/api/scam-prevention/price-advice',
      scamDetection: '/api/scam-prevention/detect',
      safetyAdvice: '/api/scam-prevention/advice',
      scamPreventionTest: '/api/scam-prevention/test',
      redFlags: '/api/scam-prevention/red-flags',
      scamPreventionHealth: '/api/scam-prevention/health',

      // Currency
      currency: '/api/currency',
      currencyConvert: '/api/currency/convert',
      currencyExchangeRates: '/api/currency/exchange-rates',
      currencyInfo: '/api/currency/info/:currency',
      currencyMarketInsights: '/api/currency/market-insights',
      currencySupported: '/api/currency/supported',
      currencyHealth: '/api/currency/health',
      currencyTest: '/api/currency/test',
    },
    quickTest: {
      translation: {
        method: 'POST',
        url: '/api/translation/test',
        body: {
          message: 'Hello, how are you?',
          sourceLanguage: 'en',
          targetLanguage: 'es',
          chatflowId: 'your-chatflow-id-here',
        },
      },
      recommendations: {
        method: 'POST',
        url: '/api/recommendations/test',
        body: {
          location: 'Paris, France',
          interests: ['culture', 'food'],
          budget: 'medium',
          chatflowId: 'your-recommendations-chatflow-id-here',
        },
      },
      scamPrevention: {
        method: 'POST',
        url: '/api/scam-prevention/test',
        body: {
          testType: 'price',
          chatflowId: '07afcffe-f864-4a73-8a28-9cbf096919e5',
        },
      },
      currency: {
        method: 'POST',
        url: '/api/currency/convert',
        body: {
          amount: 100,
          fromCurrency: 'USD',
          toCurrency: 'EUR',
        },
      },
    },
  });
});

/* ------------------------------ 404 Handler ------------------------------- */

app.use('*', (req, res) => {
  res.status(404).json({
    error: 'Endpoint not found',
    message: `The requested endpoint ${req.originalUrl} does not exist`,
    availableEndpoints: [
      'GET /',

      // Translation
      'POST /api/translation/text',
      'POST /api/translation/test',
      'GET /api/translation/languages',
      'GET /api/translation/chatflows',

      // Transportation
      'POST /api/transportation/options',
      'GET /api/transportation/realtime',
      'POST /api/transportation/directions',
      'GET /api/transportation/status',
      'GET /api/transportation/help',

      // Recommendations
      'POST /api/recommendations/personalized',
      'POST /api/recommendations/cultural-etiquette',
      'POST /api/recommendations/comprehensive',
      'POST /api/recommendations/test',
      'GET /api/recommendations/health',
      'GET /api/recommendations/interests',

      // Scam Prevention
      'POST /api/scam-prevention/price-advice',
      'POST /api/scam-prevention/detect',
      'POST /api/scam-prevention/advice',
      'POST /api/scam-prevention/test',
      'GET /api/scam-prevention/red-flags',
      'GET /api/scam-prevention/health',

      // Currency (methods mirrored from your snippet)
      'POST /api/currency/convert',
      'POST /api/currency/exchange-rates',
      'GET /api/currency/info/:currency',
      'POST /api/currency/market-insights',
      'GET /api/currency/supported',
      'GET /api/currency/health',
      'POST /api/currency/test',
    ],
  });
});

/* --------------------------- Error Handler (500) -------------------------- */

app.use((error, req, res, next) => {
  console.error('Error:', error);
  res.status(500).json({
    success: false,
    error: 'Internal server error',
    message: error.message,
  });
});

/* --------------------------------- Start --------------------------------- */

app.listen(PORT, () => {
  console.log(`🚀 AI Travel Assistant API running on port ${PORT}`);
  console.log(`📚 Environment: ${process.env.NODE_ENV || 'development'}`);
  console.log(`🌐 API available at: http://localhost:${PORT}/`);
  console.log(
    `🎯 New Features: Personalized Recommendations, Cultural Etiquette, Currency Conversion & Scam Prevention`
  );
});

module.exports = app;
