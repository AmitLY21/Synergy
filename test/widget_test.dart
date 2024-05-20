// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:synergy/Helpers/email_validator.dart';
import 'package:synergy/Helpers/password_validator.dart';

void main() {

  group('Password Validation Tests', () {
    test('Empty password returns false', () {
      expect(PasswordValidator.validate(''), false);
    });

    test('Valid password returns true', () {
      expect(PasswordValidator.validate('Password123!'), true);
    });

    test('Password without a number returns false', () {
      expect(PasswordValidator.validate('Password!'), false);
    });

    test('Password without an uppercase letter returns false', () {
      expect(PasswordValidator.validate('password123!'), false);
    });
  });

  group('Email Validation Tests', () {
    test('Empty email returns false', () {
      expect(EmailValidator.validate(''), false);
    });

    test('Valid email returns true', () {
      expect(EmailValidator.validate('email@test.com'), true);
    });

    test('Email without an "@" symbol returns false', () {
      expect(EmailValidator.validate('emailtest.com'), false);
    });

    test('Email with multiple "@" symbols returns false', () {
      expect(EmailValidator.validate('e@mail@test.com'), false);
    });
  });
}
