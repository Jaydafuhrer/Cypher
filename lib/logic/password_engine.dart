import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';

class PasswordEngine {
  static const String lowercaseChars = 'abcdefghijklmnopqrstuvwxyz';
  static const String uppercaseChars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  static const String numbers = '0123456789';
  static const String symbols = '!@#\$%^&*()_+-=[]{}|;:,.<>?';

  static String generate({
    int length = 16,
    bool includeUppercase = true,
    bool includeNumbers = true,
    bool includeSymbols = true,
    String? userEntropy,
  }) {
    length = length.clamp(1, 64);

    String allowedChars = lowercaseChars;
    if (includeUppercase) allowedChars += uppercaseChars;
    if (includeNumbers) allowedChars += numbers;
    if (includeSymbols) allowedChars += symbols;

    if (allowedChars.isEmpty) allowedChars = lowercaseChars;

    final random = Random.secure();

    List<int> entropyBytes = [];
    if (userEntropy != null && userEntropy.isNotEmpty) {
      entropyBytes = sha256.convert(utf8.encode(userEntropy)).bytes;
    }

    List<String> password = [];

    if (includeUppercase)
      password.add(uppercaseChars[random.nextInt(uppercaseChars.length)]);
    if (includeNumbers) password.add(numbers[random.nextInt(numbers.length)]);
    if (includeSymbols) password.add(symbols[random.nextInt(symbols.length)]);
    password.add(lowercaseChars[random.nextInt(lowercaseChars.length)]);

    while (password.length < length) {
      int charIndex;
      if (entropyBytes.isNotEmpty) {
        int entropyInfluence =
            entropyBytes[password.length % entropyBytes.length];
        charIndex =
            (random.nextInt(allowedChars.length) + entropyInfluence) %
            allowedChars.length;
      } else {
        charIndex = random.nextInt(allowedChars.length);
      }

      charIndex = charIndex.clamp(0, allowedChars.length - 1);
      password.add(allowedChars[charIndex]);
    }

    password.shuffle(random);

    return password.join('');
  }

  static double calculateStrength(String password) {
    if (password.isEmpty) return 0.0;

    double score = 0.0;

    if (password.length > 8) score += 0.2;
    if (password.length > 12) score += 0.2;
    if (password.length > 16) score += 0.2;

    if (RegExp(r'[A-Z]').hasMatch(password)) score += 0.1;
    if (RegExp(r'[0-9]').hasMatch(password)) score += 0.1;
    if (RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(password)) score += 0.2;

    if (!score.isFinite) score = 0.0;
    return score.clamp(0.0, 1.0);
  }

  static double getSafeStrengthForUI(String password) {
    final s = calculateStrength(password);
    return (s.isFinite) ? s.clamp(0.0, 1.0) : 0.0;
  }
}
