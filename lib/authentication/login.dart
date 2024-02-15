import 'package:dict_cat_archives/dashboard.dart';
import 'package:dict_cat_archives/strings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  late UserCredential userCredential;

  Duration get loginTime => const Duration(milliseconds: 2250);

  Future<String?> _authUser(LoginData data) async {
    try {
      await auth.signInWithEmailAndPassword(
        email: data.name,
        password: data.password,
      );
      return null;
    } on FirebaseAuthException catch (e) {
      print(e.message);
      if (e.message!.contains('auth/invalid-email')) {
        return 'Invalid email address.';
      } else if (e.message!.contains('auth/user-not-found')) {
        return 'Password is incorrect.';
      } else if (e.message!.contains('auth/wrong-password')) {
        return 'Password is incorrect.';
      } else if (e.message!.contains('auth/too-many-requests')) {
        return 'Too many login attempts. Try again later.';
      } else {
        return 'Unknown error. Try again later.';
      }
    }
  }

  Future<String?> _signupUser(SignupData data) async {
    try {
      await auth.createUserWithEmailAndPassword(
        email: data.name!,
        password: data.password!,
      );
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.message!.contains('auth/email-already-in-use')) {
        return 'Email already exist.';
      } else if (e.message!.contains('auth/invalid-email')) {
        return 'Invalid email.';
      } else {
        return 'Unknown error. Try again later.';
      }
    }
  }

  Future<String> _recoverPassword(String name) {
    debugPrint('Name: $name');
    return Future.delayed(loginTime).then((_) {
      if (name.isNotEmpty) {
        return 'User not exists';
      }
      return 'HEHE';
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      theme: LoginTheme(
          primaryColor: Colors.grey,
          accentColor: const Color.fromARGB(180, 0, 83, 184),
          buttonTheme: const LoginButtonTheme(backgroundColor: Colors.green),
          textFieldStyle: const TextStyle(color: Colors.grey),
          cardTheme: const CardTheme(
              color: Colors.white, surfaceTintColor: Colors.white)),
      title: appName,
      logo: const AssetImage('assets/images/DICT-logo.png'),
      onLogin: _authUser,
      onSignup: _signupUser,
      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const Dashboard(),
        ));
      },
      onRecoverPassword: _recoverPassword,
    );
  }
}
