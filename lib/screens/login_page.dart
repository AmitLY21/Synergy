import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:synergy/constants/app_constants.dart';
import 'package:synergy/widgets/buttons_widgets/my_button.dart';
import 'package:synergy/widgets/my_header_widget.dart';
import 'package:synergy/widgets/my_text_field.dart';
import '../Helpers/helper.dart';
import '../auth/forgot_password.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;

  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var usernameTextFieldcontroller = TextEditingController();
  var passwordTextFieldcontroller = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    usernameTextFieldcontroller.dispose();
    passwordTextFieldcontroller.dispose();
  }

  void signIn() async {
    showDialog(
        context: context,
        builder: (context) => const Center(
              child: SpinKitSpinningLines(color: Colors.purple),
            ));
    print("Sign in process");
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: usernameTextFieldcontroller.text,
        password: passwordTextFieldcontroller.text,
      );
      if (context.mounted) Navigator.pop(context);
    } catch (e) {
      String errorMessage = 'An error occurred during sign in.';

      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'wrong-password':
            errorMessage = 'Invalid password or account not found.';
            break;
          case 'invalid-email':
            errorMessage = 'Invalid email address.';
            break;
          case 'user-disabled':
            errorMessage =
                'The user associated with this email has been disabled.';
            break;
          case 'user-not-found':
            errorMessage = 'No user found with this email.';
            break;
          default:
            errorMessage = 'An error occurred during sign in.';
            break;
        }
      }
      Navigator.pop(context);
      Helper.showToast(errorMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 100,
              ),
              const HeaderWidget(
                  title: AppConstants.appTitle,
                  subtitle: AppConstants.appSubtitle),
              const SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 36.0),
                child: Column(
                  children: [
                    MyTextField(
                      hint: AppConstants.emailHint,
                      controller: usernameTextFieldcontroller,
                    ),
                    const SizedBox(height: 16),
                    MyTextField(
                      hint: AppConstants.passwordHint,
                      controller: passwordTextFieldcontroller,
                      isSecured: true,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          flex: 1,
                          child: TextButton(
                            onPressed: () {
                              // Handle forgot password
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return ForgotPasswordDialog();
                                },
                              );
                            },
                            child: const Text(AppConstants.loginForgotPassword),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    MyButton(
                      buttonText: AppConstants.loginButton,
                      onPressed: () {
                        signIn();
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),
              RichText(
                text: TextSpan(
                  text: AppConstants.loginSignUp,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                  ),
                  children: [
                    TextSpan(
                      text: AppConstants.loginSignUpLink,
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
