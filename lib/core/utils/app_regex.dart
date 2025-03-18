class AppRegex {
  const AppRegex._();

  /// Email validation regex
  static final RegExp emailRegex = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
  );

  /// Password validation regex
  /// At least 8 characters, one uppercase, one number, and one special character
  static final RegExp passwordRegex = RegExp(
    r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&#])[A-Za-z\d@$!%*?&#]{8,}$",
  );

  /// Mobile number validation regex
  /// Exactly 10 digits
  static final RegExp mobileNumberRegex = RegExp(
    r"^\d{10}$",
  );

  /// Username validation regex
  /// Alphanumeric with optional underscores, 3-15 characters
  static final RegExp usernameRegex = RegExp(
    r"^[a-zA-Z0-9_]{3,15}$",
  );

  /// Alphabet-only validation regex
  /// Allows only uppercase and lowercase letters (no spaces, numbers, or special characters)
  static final RegExp alphabetOnlyRegex = RegExp(
    r"^[a-zA-Z]+$",
  );
}
