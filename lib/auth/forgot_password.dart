import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../constants/app_constants.dart';

class ForgotPasswordDialog extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();

  Future<void> _resetPassword(BuildContext context) async {
    final String email = _emailController.text.trim();
    if (email.isEmpty) {
      Fluttertoast.showToast(msg: AppConstants.toastPleaseEnterEmail);
      return;
    }

    try {
      await resetPassword(email: email);
      Fluttertoast.showToast(msg: AppConstants.toastPasswordResetEmailSent);
      Navigator.pop(context);
    } catch (error) {
      Fluttertoast.showToast(msg: AppConstants.toastFailedToSendPasswordResetEmail);
    }
  }

  Future<void> resetPassword({required String email}) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(AppConstants.forgotPasswordTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(AppConstants.forgotPasswordEnterEmail),
          const SizedBox(height: 16),
          TextField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: AppConstants.forgotPasswordEmailLabel,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(AppConstants.forgotPasswordCancelButton),
        ),
        ElevatedButton(
          onPressed: () => _resetPassword(context),
          child: const Text(AppConstants.forgotPasswordSendRequestButton),
        ),
      ],
    );
  }
}
