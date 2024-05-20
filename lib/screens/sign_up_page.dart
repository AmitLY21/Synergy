import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:synergy/Helpers/password_validator.dart';
import 'package:synergy/models/AppsFlyerService.dart';
import 'package:synergy/widgets/buttons_widgets/my_button.dart';
import 'package:synergy/widgets/my_text_field.dart';
import '../Helpers/email_validator.dart';
import '../Helpers/helper.dart';
import '../constants/app_constants.dart';
import '../widgets/my_header_widget.dart';

class SignUpPage extends StatefulWidget {
  final Function()? onTap;

  const SignUpPage({super.key, required this.onTap});

  @override
  State<StatefulWidget> createState() => _SignUpPage();
}

class _SignUpPage extends State<SignUpPage> {
  final emailTextFieldController = TextEditingController();
  final passwordTextFieldController = TextEditingController();
  final confirmPasswordTextFieldController = TextEditingController();

  void signUp() async {
    // Show loading indicator
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: SpinKitSpinningLines(color: Colors.purple),
      ),
    );
    // Make sure passwords match
    if (passwordTextFieldController.text !=
        confirmPasswordTextFieldController.text) {
      Navigator.pop(context);
      Helper.showToast('Passwords do not match');
      return;
    }

    try {
      // create a user
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailTextFieldController.text,
        password: passwordTextFieldController.text,
      );

      FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.email)
          .set({
        'username': emailTextFieldController.text.split('@')[0],
        'bio': 'Empty bio...',
        'userIssueTypes': [],
      });

      if (context.mounted){
        Navigator.pop(context);
        AppsFlyerService().logEvent("Sign-Up Successfully", {"User Email" : emailTextFieldController.text });
      }
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);

      String errorMessage = '';

      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = 'Email is already in use.';
          break;
        case 'invalid-email':
          errorMessage = 'Invalid email address.';
          break;
        case 'operation-not-allowed':
          errorMessage = 'Email/password accounts are not enabled.';
          break;
        case 'weak-password':
          errorMessage = 'Weak password. Choose a stronger password.';
          break;
        default:
          errorMessage = 'An error occurred. Please try again.';
          break;
      }
      AppsFlyerService().logEvent("Sign-Up Failed", {"User Email" : emailTextFieldController.text , "Error" : errorMessage});
      Helper.showToast(errorMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const HeaderWidget(
                  title: AppConstants.appTitle,
                  subtitle: AppConstants.passwordReq),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 36.0),
                child: Column(
                  children: [
                    MyTextField(
                      hint: AppConstants.emailHint,
                      controller: emailTextFieldController,
                    ),
                    const SizedBox(height: 16),
                    MyTextField(
                      hint: AppConstants.passwordHint,
                      controller: passwordTextFieldController,
                      isSecured: true,
                    ),
                    const SizedBox(height: 16),
                    MyTextField(
                      hint: AppConstants.signUpConfirmPasswordHint,
                      controller: confirmPasswordTextFieldController,
                      isSecured: true,
                    ),
                    const SizedBox(height: 24),
                    MyButton(
                      buttonText: AppConstants.signUpButtonText,
                      onPressed: () {
                        // Handle sign up logic and checkPassword complexity
                        if (EmailValidator.validate(emailTextFieldController.text)) {
                          if (PasswordValidator.validate(passwordTextFieldController.text)) {
                            signUp();
                          } else {
                            Fluttertoast.showToast(msg: AppConstants.passwordCheckerError);
                          }
                        } else {
                          Fluttertoast.showToast(msg: AppConstants.invalidEmailError);
                        }
          
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),
              RichText(
                text: TextSpan(
                  text: AppConstants.signUpAlreadyHaveAccount,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                  ),
                  children: [
                    TextSpan(
                      text: AppConstants.signUpLogIn,
                      style: const TextStyle(
                        color: Colors.blue,
                        fontSize: 16.0,
                      ),
                      recognizer: TapGestureRecognizer()..onTap = widget.onTap,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}

//Divider and other sign-up options
// const SizedBox(height: 16),
// Row(
//   children: const [
//     Expanded(child: Divider()),
//     Padding(
//       padding: EdgeInsets.symmetric(horizontal: 8.0),
//       child: Text(
//         AppConstants.signUpDividerText,
//         style: TextStyle(
//           color: Colors.grey,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//     ),
//     Expanded(child: Divider()),
//   ],
// ),
// const SizedBox(height: 16),
// Row(
//   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//   children: [
//     FloatingActionButton(
//       heroTag: "btnOTP",
//       onPressed: () {
//         // Handle OTP sign up
//       },
//       child:
//           (Theme.of(context).platform == TargetPlatform.iOS)
//               ? const Icon(Icons.phone_iphone)
//               : const Icon(Icons.phone_android),
//     ),
//     FloatingActionButton(
//       heroTag: "btnFB",
//       onPressed: () {
//         // Handle Facebook sign up
//       },
//       child: const Icon(Ionicons.logo_facebook),
//     ),
//     FloatingActionButton(
//       heroTag: "btnGoogle",
//       onPressed: () {
//         // Handle Google sign up
//       },
//       child: const Icon(Ionicons.logo_google),
//     ),
//   ],
// ),
