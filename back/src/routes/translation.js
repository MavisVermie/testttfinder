const express = require('express');
const Joi = require('joi');
const FlowiseService = require('../services/flowiseService');

const router = express.Router();
const flowiseService = new FlowiseService();

// Validation schemas
const textTranslationSchema = Joi.object({
  message: Joi.string().min(1).max(5000).required(),
  chatflowId: Joi.string().required(),
  sourceLanguage: Joi.string().min(2).max(10).optional(),
  targetLanguage: Joi.string().min(2).max(10).optional(),
  history: Joi.array().items(Joi.object({
    message: Joi.string().required(),
    type: Joi.string().valid('user', 'assistant').required()
  })).optional()
});

/**
 * POST /api/translation/text
 * Translate text using Flowise AI agent
 */
router.post('/text', async (req, res) => {
  try {
    const {
      message,
      chatflowId,
      sourceLanguage,
      targetLanguage,
      history
    } = req.body;

    // Basic validation
    if (!message || !chatflowId) {
      return res.status(400).json({
        success: false,
        error: 'Missing required fields',
        message: 'Both message and chatflowId are required'
      });
    }

    // Prepare options for Flowise
    const options = {
      sourceLanguage: sourceLanguage || 'auto',
      targetLanguage: targetLanguage || 'auto',
      history
    };

    // Send request to Flowise
    const result = await flowiseService.sendChatMessage(message, chatflowId, options);

    if (result.success) {
      res.json({
        success: true,
        data: {
          originalText: message,
          translatedText: result.data.answer || result.data.text || result.data.response,
          sourceLanguage: sourceLanguage || 'auto',
          targetLanguage: targetLanguage || 'auto',
          timestamp: new Date().toISOString()
        },
        message: 'Text translation completed successfully'
      });
    } else {
      res.status(result.statusCode || 500).json({
        success: false,
        error: result.error,
        message: 'Failed to translate text'
      });
    }
  } catch (error) {
    console.error('Text translation error:', error);
    res.status(500).json({
      success: false,
      error: 'Internal server error during text translation',
      message: error.message
    });
  }
});

/**
 * POST /api/translation/test
 * Simple test endpoint for easy API testing
 */
router.post('/test', async (req, res) => {
  try {
    const { message, sourceLanguage, targetLanguage, chatflowId } = req.body;

    // Validate required fields
    if (!message || !chatflowId) {
      return res.status(400).json({
        success: false,
        error: 'Missing required fields',
        message: 'Both message and chatflowId are required'
      });
    }

    // Prepare options for Flowise
    const options = {
      sourceLanguage: sourceLanguage || 'auto',
      targetLanguage: targetLanguage || 'auto'
    };

    // Send request to Flowise
    const result = await flowiseService.sendChatMessage(message, chatflowId, options);

    if (result.success) {
      res.json({
        success: true,
        data: {
          originalText: message,
          translatedText: result.data.answer || result.data.text || result.data.response,
          sourceLanguage: sourceLanguage || 'auto',
          targetLanguage: targetLanguage || 'auto',
          timestamp: new Date().toISOString()
        },
        message: 'Test translation completed successfully'
      });
    } else {
      res.status(result.statusCode || 500).json({
        success: false,
        error: result.error,
        message: 'Failed to translate text'
      });
    }
  } catch (error) {
    console.error('Test translation error:', error);
    res.status(500).json({
      success: false,
      error: 'Internal server error during test translation',
      message: error.message
    });
  }
});

/**
 * GET /api/translation/chatflows
 * Get available chatflows from Flowise
 */
router.get('/chatflows', async (req, res) => {
  try {
    const result = await flowiseService.getChatflows();

    if (result.success) {
      res.json({
        success: true,
        data: result.data,
        message: 'Chatflows retrieved successfully'
      });
    } else {
      res.status(result.statusCode || 500).json({
        success: false,
        error: result.error,
        message: 'Failed to retrieve chatflows'
      });
    }
  } catch (error) {
    console.error('Get chatflows error:', error);
    res.status(500).json({
      success: false,
      error: 'Internal server error while retrieving chatflows',
      message: error.message
    });
  }
});

/**
 * GET /api/translation/languages
 * Get supported languages for translation
 */
router.get('/languages', (req, res) => {
  res.json({
    success: true,
    data: {
      supportedLanguages: [
        { code: 'en', name: 'English' },
        { code: 'es', name: 'Spanish' },
        { code: 'fr', name: 'French' },
        { code: 'de', name: 'German' },
        { code: 'it', name: 'Italian' },
        { code: 'pt', name: 'Portuguese' },
        { code: 'ru', name: 'Russian' },
        { code: 'ja', name: 'Japanese' },
        { code: 'ko', name: 'Korean' },
        { code: 'zh', name: 'Chinese' },
        { code: 'ar', name: 'Arabic' },
        { code: 'hi', name: 'Hindi' },
        { code: 'th', name: 'Thai' },
        { code: 'vi', name: 'Vietnamese' },
        { code: 'auto', name: 'Auto-detect' }
      ],
      commonTouristLanguages: [
        'en', 'es', 'fr', 'de', 'it', 'pt', 'ja', 'ko', 'zh', 'ar'
      ]
    },
    message: 'Supported languages retrieved successfully'
  });
});

module.exports = router;
