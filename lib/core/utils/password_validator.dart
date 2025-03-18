import 'package:flutter/material.dart';

/// Custom Password Strength Validator
class PasswordValidator {
  /// Validates password strength and returns a strength level
  static String getPasswordStrength(String password) {
    int strength = 0;

    // Check length
    if (password.length >= 8) strength++;

    // Check if contains uppercase letter
    if (password.contains(RegExp(r'[A-Z]'))) strength++;

    // Check if contains number
    if (password.contains(RegExp(r'[0-9]'))) strength++;

    // Check if contains special character
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) strength++;

    // Return password strength level
    if (strength <= 1) return "Weak";
    if (strength == 2) return "Medium";
    return "Strong";
  }

  /// Returns color based on password strength
  static Color getStrengthColor(String strength) {
    switch (strength) {
      case "Weak":
        return Colors.red;
      case "Medium":
        return Colors.orange;
      case "Strong":
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  /// Returns progress percentage for strength meter
  static double getStrengthProgress(String strength) {
    switch (strength) {
      case "Weak":
        return 0.3;
      case "Medium":
        return 0.6;
      case "Strong":
        return 1.0;
      default:
        return 0.0;
    }
  }
}
