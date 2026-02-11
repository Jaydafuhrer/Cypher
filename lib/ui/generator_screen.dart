import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import '../logic/password_engine.dart';
import 'widgets/glass_button.dart';
import 'widgets/glass_card.dart';
import 'widgets/strength_indicator.dart';

double safeDouble(
  double value, {
  double min = 0.0,
  double max = double.infinity,
}) {
  if (!value.isFinite) return min;
  return value.clamp(min, max);
}

class GeneratorScreen extends StatefulWidget {
  const GeneratorScreen({super.key});

  @override
  State<GeneratorScreen> createState() => _GeneratorScreenState();
}

class _GeneratorScreenState extends State<GeneratorScreen> {
  String _password = '';
  double _length = 16;
  bool _useUppercase = true;
  bool _useNumbers = true;
  bool _useSymbols = true;
  final TextEditingController _entropyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _generatePassword();
  }

  void _generatePassword() {
    setState(() {
      final safeLength = safeDouble(_length, min: 8, max: 64).toInt();

      _password = PasswordEngine.generate(
        length: safeLength,
        includeUppercase: _useUppercase,
        includeNumbers: _useNumbers,
        includeSymbols: _useSymbols,
        userEntropy: _entropyController.text,
      );
    });
  }

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: _password));
    Fluttertoast.showToast(
      msg: "Password copied to clipboard!",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.purpleAccent,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    final strength = safeDouble(
      PasswordEngine.calculateStrength(_password),
      min: 0,
      max: 1,
    );

    return Scaffold(
      backgroundColor: const Color(0xFF0F0C29),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0F0C29), Color(0xFF302B63), Color(0xFF24243E)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Title
                Text(
                      'Cypher',
                      style: GoogleFonts.outfit(
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 2,
                      ),
                    )
                    .animate()
                    .fadeIn(duration: safeDouble(800).ms)
                    .slideY(begin: safeDouble(-0.2)),

                const SizedBox(height: 8),
                Text(
                  'Generate Unhackable Passwords',
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.6),
                  ),
                ).animate().fadeIn(delay: safeDouble(400).ms),

                const SizedBox(height: 48),

                // Password Display
                GlassCard(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              _password,
                              style: GoogleFonts.jetBrainsMono(
                                fontSize: 24,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.copy, color: Colors.white),
                            onPressed: _copyToClipboard,
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.refresh,
                              color: Colors.white,
                            ),
                            onPressed: _generatePassword,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      StrengthIndicator(strength: strength),
                    ],
                  ),
                ).animate().scale(delay: safeDouble(600).ms),

                const SizedBox(height: 32),

                // Controls
                GlassCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildControlHeader(
                            'Password Length: ${safeDouble(_length, min: 8, max: 64).toInt()}',
                          ),
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              activeTrackColor: Colors.purpleAccent,
                              inactiveTrackColor: Colors.white.withOpacity(0.1),
                              thumbColor: Colors.white,
                              overlayColor: Colors.purpleAccent.withOpacity(
                                0.2,
                              ),
                            ),
                            child: Slider(
                              value: safeDouble(_length, min: 8, max: 64),
                              min: 8,
                              max: 64,
                              onChanged: (val) {
                                setState(
                                  () => _length = safeDouble(
                                    val,
                                    min: 8,
                                    max: 64,
                                  ),
                                );
                                _generatePassword();
                              },
                            ),
                          ),
                          const SizedBox(height: 24),
                          _buildSwitch('Include Uppercase', _useUppercase, (
                            val,
                          ) {
                            setState(() => _useUppercase = val);
                            _generatePassword();
                          }),
                          _buildSwitch('Include Numbers', _useNumbers, (val) {
                            setState(() => _useNumbers = val);
                            _generatePassword();
                          }),
                          _buildSwitch('Include Symbols', _useSymbols, (val) {
                            setState(() => _useSymbols = val);
                            _generatePassword();
                          }),
                          const SizedBox(height: 24),
                          Text(
                            'Seed Entropy (Optional)',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _entropyController,
                            onChanged: (_) => _generatePassword(),
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: 'Enter Secret Phrase',
                              hintStyle: TextStyle(
                                color: Colors.white.withOpacity(0.3),
                              ),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.05),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.all(16),
                            ),
                          ),
                        ],
                      ),
                    )
                    .animate()
                    .fadeIn(delay: safeDouble(800).ms)
                    .slideY(begin: safeDouble(0.1)),

                const SizedBox(height: 48),

                GlassButton(
                  label: 'GENERATE STRONG PASSWORD',
                  icon: Icons.security,
                  onPressed: _generatePassword,
                ).animate().fadeIn(delay: safeDouble(1000).ms),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildControlHeader(String title) => Text(
    title,
    style: const TextStyle(
      color: Colors.white,
      fontSize: 16,
      fontWeight: FontWeight.w600,
    ),
  );

  Widget _buildSwitch(String title, bool value, ValueChanged<bool> onChanged) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 15,
              ),
            ),
            Switch(
              value: value,
              onChanged: onChanged,
              activeThumbColor: Colors.purpleAccent,
              activeTrackColor: Colors.purpleAccent.withOpacity(0.3),
            ),
          ],
        ),
      );
}
