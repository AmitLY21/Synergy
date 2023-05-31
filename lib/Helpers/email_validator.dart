class EmailValidator {
  // Private constructor
  EmailValidator._();

  static final EmailValidator _instance = EmailValidator._();

  factory EmailValidator() => _instance;

  static bool validate(String email) {
    final RegExp emailRegex = RegExp(
      r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$',
    );

    return emailRegex.hasMatch(email);
  }
}
