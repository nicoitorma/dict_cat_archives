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
    String checked = _checkInput(data);
    if (checked == 'null') {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: data.name, password: data.password);
      } on FirebaseAuthException catch (e) {
        debugPrint(e.message);
      } catch (e) {
        debugPrint(e.toString());
      }
    } else {
      return checked;
    }
    return null;
  }

  String _checkInput(data) {
    if (data.name.isEmpty) {
      return 'User not exists';
    }
    if (data.password.isEmpty) {
      return 'Password does not match';
    }
    return 'null';
  }

  Future<String?> _signupUser(SignupData data) async {
    try {
      userCredential = await auth.createUserWithEmailAndPassword(
          email: data.name!, password: data.password!);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return 'Email already in use';
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return null;
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
          buttonTheme: const LoginButtonTheme(backgroundColor: Colors.green),
          cardTheme: const CardTheme(color: Colors.white)),
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
