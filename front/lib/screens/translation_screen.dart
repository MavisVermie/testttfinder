import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class TranslationScreen extends StatefulWidget {
  const TranslationScreen({super.key});

  @override
  State<TranslationScreen> createState() => _TranslationScreenState();
}

class _TranslationScreenState extends State<TranslationScreen> {
  final TextEditingController _inputController = TextEditingController();
  final TextEditingController _outputController = TextEditingController(text: '');

  String _fromLang = 'English';
  String _toLang = 'Spanish';

  final List<String> _languages = const [
    'English',
    'Spanish',
    'French',
    'German',
    'Italian',
    'Portuguese',
    'Chinese',
    'Japanese',
    'Korean',
    'Arabic',
    'Russian',
    'Hindi',
  ];

  @override
  void dispose() {
    _inputController.dispose();
    _outputController.dispose();
    super.dispose();
  }

  void _swapLanguages() {
    setState(() {
      final String temp = _fromLang;
      _fromLang = _toLang;
      _toLang = temp;
    });
  }

  void _openImagePickerSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Take a photo'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Upload from gallery'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          'Translate',
          style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: const Color(0xFF1C2F69)),
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1C2F69),
        centerTitle: true,
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
            // Language selection bar
            Container(
              color: Colors.transparent,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _fromLang,
                      style: GoogleFonts.inter(color: const Color(0xFF1C2F69)),
                      decoration: InputDecoration(
                        labelText: 'From',
                        labelStyle: GoogleFonts.inter(color: const Color(0xFF1C2F69)),
                        border: const OutlineInputBorder(),
                        isDense: true,
                      ),
                      items: _languages
                          .map((l) => DropdownMenuItem<String>(value: l, child: Text(l)))
                          .toList(),
                      onChanged: (val) => setState(() => _fromLang = val ?? _fromLang),
                    ),
                  ),
                  const SizedBox(width: 12),
                  IconButton(
                    onPressed: _swapLanguages,
                    icon: const Icon(Icons.swap_horiz),
                    style: IconButton.styleFrom(
                      backgroundColor: AppTheme.primaryOrange,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _toLang,
                      style: GoogleFonts.inter(color: const Color(0xFF1C2F69)),
                      decoration: InputDecoration(
                        labelText: 'To',
                        labelStyle: GoogleFonts.inter(color: const Color(0xFF1C2F69)),
                        border: const OutlineInputBorder(),
                        isDense: true,
                      ),
                      items: _languages
                          .map((l) => DropdownMenuItem<String>(value: l, child: Text(l)))
                          .toList(),
                      onChanged: (val) => setState(() => _toLang = val ?? _toLang),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Main panels (stacked for mobile like Yandex)
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                ),
                child: Column(
                  children: [
                    // Input panel
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Input',
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF1C2F69),
                                  ),
                                ),
                                const Spacer(),
                                IconButton(
                                  tooltip: 'Camera',
                                  onPressed: _openImagePickerSheet,
                                  icon: const Icon(Icons.photo_camera_outlined),
                                ),
                                IconButton(
                                  tooltip: 'Microphone',
                                  onPressed: () {},
                                  icon: const Icon(Icons.mic_none),
                                ),
                                IconButton(
                                  tooltip: 'Listen',
                                  onPressed: () {},
                                  icon: const Icon(Icons.volume_up_outlined),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: _inputController,
                              minLines: 5,
                              maxLines: 10,
                              cursorColor: const Color(0xFF1C2F69),
                              style: GoogleFonts.inter(color: const Color(0xFF1C2F69), fontSize: 14),
                              decoration: InputDecoration(
                                hintText: 'Type text here or use the mic/camera…',
                                hintStyle: GoogleFonts.inter(color: const Color(0xFF1C2F69).withOpacity(0.5)),
                                border: const OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                ElevatedButton(
                                  onPressed: () {},
                                  child: const Text('Translate'),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Output panel
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Output',
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF1C2F69),
                                  ),
                                ),
                                const Spacer(),
                                IconButton(
                                  tooltip: 'Listen',
                                  onPressed: () {},
                                  icon: const Icon(Icons.volume_up_outlined),
                                ),
                                IconButton(
                                  tooltip: 'Copy',
                                  onPressed: () {},
                                  icon: const Icon(Icons.copy_outlined),
                                ),
                                IconButton(
                                  tooltip: 'Share',
                                  onPressed: () {},
                                  icon: const Icon(Icons.ios_share),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: _outputController,
                              minLines: 5,
                              maxLines: 10,
                              readOnly: true,
                              cursorColor: const Color(0xFF1C2F69),
                              style: GoogleFonts.inter(color: const Color(0xFF1C2F69), fontSize: 14),
                              decoration: InputDecoration(
                                hintText: 'Translation will appear here',
                                hintStyle: GoogleFonts.inter(color: const Color(0xFF1C2F69).withOpacity(0.5)),
                                border: const OutlineInputBorder(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
              ],
            ),
          ),
        ],
      ),
    );
  }

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
