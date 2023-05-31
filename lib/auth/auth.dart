import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../screens/home_page.dart';
import 'login_or_register.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context,snapshot){
          //User Logged in
          if(snapshot.hasData){
            return const HomePage();//Will redirect to home page
          }
          //User NOT logged in
          else{
            return const LoginOrRegister();
          }
        });
  }
}
