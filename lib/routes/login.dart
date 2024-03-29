import 'package:dict_cat_archives/routes/dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:particles_flutter/particles_flutter.dart';

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
      if (e.message!.contains('auth/invalid-email')) {
        return 'Invalid email address.';
      } else if (e.message!.contains('auth/network-request-failed')) {
        return 'Slow Internet Connection.';
      } else if (e.message!.contains('auth/invalid-credential')) {
        return 'Invalid Email or Password.';
      } else if (e.message!.contains('auth/too-many-requests')) {
        return 'Too many login attempts. Try again later.';
      } else {
        return 'Unknown error. Try again later.';
      }
    }
  }

  // Future<String?> _signupUser(SignupData data) async {
  //   try {
  //     await auth.createUserWithEmailAndPassword(
  //       email: data.name!,
  //       password: data.password!,
  //     );
  //     return null;
  //   } on FirebaseAuthException catch (e) {
  //     if (e.message!.contains('auth/email-already-in-use')) {
  //       return 'Email already exist.';
  //     } else if (e.message!.contains('auth/invalid-email')) {
  //       return 'Invalid email.';
  //     } else {
  //       return 'Unknown error. Try again later.';
  //     }
  //   }
  // }

  Future<String?> _recoverPassword(String name) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: name);
      return null;
    } catch (error) {
      return 'Error sending password reset email: $error';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      CircularParticle(
        key: UniqueKey(),
        awayRadius: 360,
        numberOfParticles: 200,
        speedOfParticles: 1,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        onTapAnimation: true,
        particleColor: Colors.grey,
        awayAnimationDuration: const Duration(milliseconds: 600),
        maxParticleSize: 3,
        isRandSize: true,
        isRandomColor: true,
        randColorList: const [
          Color.fromARGB(255, 155, 11, 1),
          Colors.white,
          Colors.yellow,
          Color.fromARGB(255, 2, 70, 126)
        ],
        awayAnimationCurve: Curves.easeInOutBack,
        enableHover: true,
        hoverColor: Colors.white,
        hoverRadius: 90,
        connectDots: true,
      ),
      FlutterLogin(
        theme: LoginTheme(
            primaryColor: Colors.transparent,
            accentColor: const Color.fromARGB(180, 0, 83, 184),
            buttonTheme: const LoginButtonTheme(backgroundColor: Colors.green),
            textFieldStyle: const TextStyle(
              color: Color.fromARGB(180, 0, 83, 184),
              fontFamily: 'Poppins',
            ),
            titleStyle: const TextStyle(fontFamily: 'Poppins'),
            bodyStyle: const TextStyle(fontFamily: 'Poppins'),
            cardTheme: CardTheme(
                color: Colors.grey[100], surfaceTintColor: Colors.grey[100])),
        title: 'DICT Archives',
        logo: const AssetImage('assets/images/DICT-logo.png'),
        onLogin: _authUser,
        onSubmitAnimationCompleted: () {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => const Dashboard(),
          ));
        },
        onRecoverPassword: _recoverPassword,
        messages: LoginMessages(
          recoverPasswordDescription:
              'Recovery procedure will be sent to the email.',
          recoverPasswordSuccess: 'Email sent successfully.',
        ),
      ),
    ]);
  }
}
