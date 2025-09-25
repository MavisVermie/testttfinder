import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../theme/app_theme.dart';
import '../services/recommendations_service.dart';

class RecommendationsScreen extends StatefulWidget {
  const RecommendationsScreen({super.key});

  @override
  State<RecommendationsScreen> createState() => _RecommendationsScreenState();
}

class _RecommendationsScreenState extends State<RecommendationsScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;
  final RecommendationsService _service = RecommendationsService();

  // Chat history (dynamic, filled by user/AI messages)
  List<Map<String, String>> _messages = [];

  @override
  void initState() {
    super.initState();
    _loadChatHistory();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // Load chat history from SharedPreferences
  Future<void> _loadChatHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? chatHistoryJson = prefs.getString('recommendations_chat_history');
      if (chatHistoryJson != null) {
        final List<dynamic> chatHistoryList = json.decode(chatHistoryJson);
        setState(() {
          _messages = chatHistoryList
              .map((item) => Map<String, String>.from(item))
              .toList();
        });
      }
    } catch (e) {
      print('Error loading chat history: $e');
    }
  }

  // Save chat history to SharedPreferences
  Future<void> _saveChatHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String chatHistoryJson = json.encode(_messages);
      await prefs.setString('recommendations_chat_history', chatHistoryJson);
    } catch (e) {
      print('Error saving chat history: $e');
    }
  }

  void _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty || _isTyping) return;

    setState(() {
      _messages.add({'role': 'user', 'text': text});
      _messageController.clear();
      _isTyping = true;
    });

    // Save chat history after adding user message
    _saveChatHistory();
    _scrollToBottom();

    try {
      // Using the dedicated AI chat API for recommendations
      const chatflowId = '32547d3e-ba39-4604-a904-da0c516e17b1';

      final result = await _service.getPersonalized(
        userMessage: text,
        chatflowId: chatflowId,
      );

      if (!mounted) return;

      if (result['success'] == true) {
        final data = (result['data'] as Map<String, dynamic>? ?? <String, dynamic>{});
        final recs = data['recommendations'];
        String reply;
        
        if (recs is Map<String, dynamic>) {
          // Handle structured response - check multiple possible response fields
          final rawResponse = recs['rawResponse']?.toString() ?? '';
          final contentResponse = recs['content']?.toString() ?? '';
          final textResponse = recs['text']?.toString() ?? 
                             recs['answer']?.toString() ?? 
                             recs['response']?.toString() ?? '';
          
          if (rawResponse.isNotEmpty) {
            reply = rawResponse;
          } else if (contentResponse.isNotEmpty) {
            reply = contentResponse;
          } else if (textResponse.isNotEmpty) {
            reply = textResponse;
          } else {
            // If no specific response field found, try to get any string value
            final anyResponse = recs.values
                .where((value) => value is String && value.isNotEmpty)
                .cast<String>()
                .firstOrNull ?? '';
            reply = anyResponse.isNotEmpty ? anyResponse : 'I understand your request. Let me provide you with some personalized travel recommendations!';
          }
        } else if (recs is String) {
          reply = recs;
        } else if (recs != null) {
          reply = recs.toString();
        } else {
          reply = 'I understand your request. Let me provide you with some personalized travel recommendations!';
        }
        
        setState(() {
          _messages.add({'role': 'ai', 'text': reply});
          _isTyping = false;
        });
        // Save chat history after AI response
        _saveChatHistory();
      } else {
        final message = result['message']?.toString() ?? 
                       result['error']?.toString() ?? 
                       'Sorry, I encountered an issue while processing your request. Please try again.';
        setState(() {
          _messages.add({'role': 'ai', 'text': '🤖 $message'});
          _isTyping = false;
        });
        // Save chat history after error response
        _saveChatHistory();
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _messages.add({'role': 'ai', 'text': '🤖 Sorry, I encountered a technical issue. Please check your internet connection and try again.'});
        _isTyping = false;
      });
      // Save chat history after error
      _saveChatHistory();
    } finally {
      _scrollToBottom();
    }
  }

  // Removed mock reply generator now that backend is wired

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 80,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppTheme.darkBlue,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        toolbarHeight: 44,
      ),
      body: Stack(
        children: [
          // Decorative background shapes (match homepage style)
          Positioned(
            top: -80,
            left: -60,
            child: _blob(180, AppTheme.primaryOrange.withOpacity(0.15)),
          ),
          Positioned(
            top: 120,
            right: -40,
            child: _blob(120, AppTheme.primaryBlue.withOpacity(0.12)),
          ),
          Positioned(
            bottom: 80,
            left: -50,
            child: _blob(140, AppTheme.lightBlue.withOpacity(0.10)),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Chat area only
                  Expanded(
                    child: Card(
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.white,
                        ),
                        child: Column(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                controller: _scrollController,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                  horizontal: 12,
                                ),
                                itemCount: _messages.length + (_isTyping ? 1 : 0),
                                itemBuilder: (context, index) {
                                  if (_isTyping && index == _messages.length) {
                                    return _buildTypingIndicator();
                                  }
                                  final message = _messages[index];
                                  final isUser = message['role'] == 'user';
                                  return _buildChatBubble(
                                    text: message['text'] ?? '',
                                    isUser: isUser,
                                  );
                                },
                              ),
                            ),
                            const Divider(height: 1),
                            _buildComposer(),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComposer() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _sendMessage(),
              decoration: InputDecoration(
                hintText: 'Ask for places, plans, or tips…',
                hintStyle: GoogleFonts.inter(fontSize: 14),
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppTheme.primaryBlue),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: _sendMessage,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryBlue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Icon(Icons.send_rounded, size: 18),
          ),
        ],
      ),
    );
  }

  Widget _buildChatBubble({required String text, required bool isUser}) {
    final bg = isUser
        ? AppTheme.primaryBlue
        : Colors.grey.shade100;
    final fg = isUser ? Colors.white : AppTheme.textPrimary;
    // alignment is determined by Row and textAlign below
    final radius = isUser
        ? const BorderRadius.only(
            topLeft: Radius.circular(14),
            topRight: Radius.circular(14),
            bottomLeft: Radius.circular(14),
          )
        : const BorderRadius.only(
            topLeft: Radius.circular(14),
            topRight: Radius.circular(14),
            bottomRight: Radius.circular(14),
          );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isUser)
            CircleAvatar(
              radius: 14,
              backgroundColor: AppTheme.primaryOrange,
              child: const Icon(Icons.smart_toy_rounded, size: 16, color: Colors.white),
            ),
          if (!isUser) const SizedBox(width: 8),
          Flexible(
            child: Container(
              decoration: BoxDecoration(
                color: bg,
                borderRadius: radius,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Text(
                text,
                style: GoogleFonts.inter(
                  color: fg,
                  fontSize: 14,
                ),
                textAlign: isUser ? TextAlign.right : TextAlign.left,
              ),
            ),
          ),
          if (isUser) const SizedBox(width: 8),
          if (isUser)
            CircleAvatar(
              radius: 14,
              backgroundColor: AppTheme.primaryBlue,
              child: const Icon(Icons.person, size: 16, color: Colors.white),
            ),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: AppTheme.primaryOrange,
            child: const Icon(Icons.smart_toy_rounded, size: 16, color: Colors.white),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: const BorderRadius.all(Radius.circular(14)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _dot(),
                const SizedBox(width: 4),
                _dot(delay: 150),
                const SizedBox(width: 4),
                _dot(delay: 300),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _dot({int delay = 0}) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.3, end: 1.0),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: child,
        );
      },
      onEnd: () {},
      child: Container(
        width: 6,
        height: 6,
        decoration: BoxDecoration(
          color: AppTheme.textSecondary,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  // Removed mock Do & Don't card and bullets

  Widget _blob(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 24,
            spreadRadius: 6,
          ),
        ],
      ),
    );
  }
}
