class PasswordValidator {
  // Private constructor
  PasswordValidator._();

  static final PasswordValidator _instance = PasswordValidator._();

  factory PasswordValidator() => _instance;

  static bool validate(String password) {
    final RegExp passwordRegex = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*()\-_=+{};:,<.>]).{8,}$',
    );

    return passwordRegex.hasMatch(password);
  }
}
